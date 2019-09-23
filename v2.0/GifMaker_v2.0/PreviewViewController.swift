//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by 강선미 on 02/09/2019.
//  Copyright © 2019 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit



protocol PreviewViewControllerDelegate: class {
    //source : https://stackoverflow.com/questions/29025876/why-custom-delegate-in-ios-is-not-called
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif)
}

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var gifImageView: UIImageView!
    var gif: Gif?
    var previewDelegate: PreviewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let gifImage = gif?.gifImage {
           gifImageView.image = gifImage
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareGif(_ sender: Any) {
        
        let url: URL = (self.gif?.url)!
        let animatedGIF = NSData(contentsOf: url)!
        let itemsToShare = [animatedGIF]
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        navigationController?.present(activityVC, animated: true, completion: nil)
    }
    

    @IBAction func createAndSave(_ sender: Any) {
         previewDelegate?.previewVC(preview: self, didSaveGif: gif!)
         navigationController?.popToRootViewController(animated: true)
 
    }
    

}
