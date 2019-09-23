//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by 강선미 on 02/09/2019.
//  Copyright © 2019 Gabrielle Miller-Messner. All rights reserved.
//
import Foundation
import UIKit

class GifEditorViewController : UIViewController, UITextFieldDelegate {

    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    //var gifURL: NSURL? = nil
    var gif:Gif?
    
    // make gif by calling method gifwithURL
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextField.delegate = self
        // Do any additional setup after loading the view.
        gifImageView.image = gif?.gifImage
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    // Called just before UITextField is edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    // Called when the line feed button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Process of closing the Keyboard when the line feed button is pressed.
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func presentPreview(_ sender: Any) {
        let previewVC = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        gif?.caption = captionTextField.text
        
        let regift = Regift(sourceFileURL: (gif?.videoURL)!, destinationFileURL: nil, frameCount:  UIViewController.frameCount, delayTime: UIViewController.delayTime, loopCount: UIViewController.loopCount, size: gif?.gifImage?.size, progress: nil)
        let captionFont: UIFont = captionTextField.font!
        let gifURL: URL = regift.createGif(caption: captionTextField.text, font: captionFont)!
        print(gifURL)
        
        let newGif = Gif(url: gifURL, rawVideoURL: (gif?.videoURL)!, caption: captionTextField.text, name: "")
        
        previewVC.gif = newGif
        //previewVC.previewDelegate = navigationController?.viewControllers.first as! SavedGifsViewController
        navigationController?.pushViewController(previewVC, animated: true)
        
    }
    
}

extension GifEditorViewController
{
    // MARK: observe and respond to keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // keyboard show & hide
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y >= 0 {
            // get frame rect ,set keyboard height when showing
            var rect = self.view.frame
            rect.origin.y -= getKeyboardHeight(notification: notification)
            self.view.frame = rect
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y < 0 {
            // get frame rect, set keyboard y pos
            var rect = self.view.frame
            rect.origin.y += getKeyboardHeight(notification: notification)
            self.view.frame = rect
        }
    }
    
    // get keyboard size (width, height)
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
}
