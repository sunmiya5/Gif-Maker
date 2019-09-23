//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by 강선미 on 02/09/2019.
//  Copyright © 2019 Gabrielle Miller-Messner. All rights reserved.
//


import Foundation
import UIKit
import AVFoundation
import MobileCoreServices
import Photos

extension UIViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 // Regift constants
    static let frameCount = 16
    static let delayTime: Float = 0.2
    static let loopCount = 0 // 0 means loop forever
    static let frameRate = 15
    
    @IBAction func presentVideoOptions() {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
             launchPhotoLibrary()
        } else {
            let newGifActionSheet: UIAlertController = UIAlertController(title: "Create New Gif", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            let recordVideo: UIAlertAction = UIAlertAction(title: "Record Video", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                self.launchCamera()
            })
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing" , style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
  
                self.launchPhotoLibrary()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
         
            newGifActionSheet.addAction(recordVideo)
            newGifActionSheet.addAction(chooseFromExisting)
            newGifActionSheet.addAction(cancel)
            
            let pinkColor = UIColor(red: 255.0/255.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            newGifActionSheet.view.tintColor = pinkColor
            present(newGifActionSheet, animated: true, completion: nil)
        }
    }
    
    
    public func launchCamera() {
        present(pickerControllerWithSource(source: UIImagePickerController.SourceType.camera), animated: true, completion: nil)
    }
    
    public func launchPhotoLibrary() {
        present(pickerControllerWithSource(source: UIImagePickerController.SourceType.photoLibrary), animated: true, completion: nil)
    }
    
    func pickerControllerWithSource(source: UIImagePickerController.SourceType) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.allowsEditing = true
        picker.delegate = self
        
        return picker
    }
    
    public func launchVideoCamera(sender: AnyObject) {
        // create imagePicker
        let recordVideoController = UIImagePickerController()
        // set properties: sourcetype, mediatypes, allowsEditing, delegate
        recordVideoController.sourceType = UIImagePickerController.SourceType.camera
        recordVideoController.mediaTypes = [kUTTypeMovie as String]
        recordVideoController.allowsEditing = false
        recordVideoController.delegate = self
        
        present(recordVideoController, animated: true, completion: nil)
        
    }
// ImagePickerController Delegate Methods (Allows Editing)
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                                                                info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[.mediaType] as! String
     //Handle a movie capture
        if mediaType == kUTTypeMovie as String {
            let videoURL = info[.mediaURL] as! URL
            //Get start and end points from trimmed video
            let start = info[UIImagePickerController.InfoKey(rawValue: "_UIImagePickerControllerVideoEditingStart")] as? NSNumber
            let end = info[UIImagePickerController.InfoKey(rawValue: "_UIImagePickerControllerVideoEditingEnd")] as? NSNumber
            var duration: NSNumber?
            
            DispatchQueue.main.async {
                if let start = start {
                    duration = NSNumber(value: (end!.floatValue) - (start.floatValue))
                    self.cropVideoToSquare(rawVideoURL: videoURL, start: Float(truncating: start), duration: Float(truncating: duration!))
                } else {
                    duration = nil
                    self.cropVideoToSquare(rawVideoURL: videoURL)
                    
                }
            }
//            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, nil, nil, nil)
//            dismiss(animated: true, completion: nil)

            // this code makes error and block temporary
             dismiss(animated: true, completion: nil)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func cropVideoToSquare(rawVideoURL: URL, start: Float? = nil, duration: Float? = nil) {
        // Initialize the AVAsset and AVAssetTrack
        let videoAsset = AVAsset(url: rawVideoURL as URL)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video)
        
        // Initialize video composition and set properties
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack[0].naturalSize.height,
                                             height: videoTrack[0].naturalSize.height)
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        // Initialize instruction and set time range
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: CMTime.zero, duration: CMTimeMakeWithSeconds(60, preferredTimescale: 30))
        
        // Rotate to portrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack[0])
        let t1 = CGAffineTransform(translationX: videoTrack[0].naturalSize.height, y: -(videoTrack[0].naturalSize.width - videoTrack[0].naturalSize.height)/2 )
        // Rotate 90 degrees to portrait
        let t2 = t1.rotated(by: CGFloat(Float.pi/2))
        
        let finalTrasform = t2
        transformer.setTransform(finalTrasform, at: CMTime.zero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        // Export the square video
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.videoComposition = videoComposition
        let path = createPath()
        exporter?.outputURL = URL(fileURLWithPath: path as String)
        exporter?.outputFileType = AVFileType.mov
        
        var croppedURL: URL?
        
        exporter?.exportAsynchronously {
            croppedURL = exporter?.outputURL
            print("cropped url: \(String(describing: croppedURL?.absoluteString))")
            DispatchQueue.main.async {
                if let start = start {
                    self.convertVideoToGIF(videoURL: croppedURL!, start: start, duration: duration)
                } else {
                    self.convertVideoToGIF(videoURL: croppedURL!)
                }
            }
        }
    }
    func createPath() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let manager = FileManager.default
        var outputURL = documentsDirectory.appendingPathComponent("output.mov") as NSString
        
        do {
            try manager.createDirectory(atPath: outputURL as String, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error when creating path to directory")
        }
        
        outputURL = outputURL.appendingPathComponent("output.mov") as NSString
        
        do {
            try manager.removeItem(atPath: outputURL as String)
        } catch {
            print("Error when removing output URL from File Manager")
        }
        
        return outputURL
    }
    
// GIF conversion methods
    func convertVideoToGIF(videoURL: URL, start: Float? = nil, duration: Float? = nil) {
        let regift: Regift!

        if let start = start {
            regift = Regift(sourceFileURL: videoURL, startTime: start, duration: duration!, frameRate: UIViewController.frameRate)
        } else {
           regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, frameCount: UIViewController.frameCount, delayTime: UIViewController.delayTime, loopCount: UIViewController.loopCount, size: nil, progress: nil)
        }
        
        let gifURL = regift.createGif()
        saveGif(url: gifURL!, videoURL: videoURL)
    }
    
    
    func saveGif(url: URL, videoURL: URL) {
        let newGif = Gif(url: url, rawVideoURL: videoURL, caption: nil, name: nil)
        displayGIF(gif: newGif)
    }
    func displayGIF(gif: Gif) {
        let gifEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gifEditorVC.gif = gif
        navigationController?.pushViewController(gifEditorVC, animated: true)
    }
    
  
}

