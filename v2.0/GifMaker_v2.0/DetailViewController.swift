//
//  DetailViewController.swift
//  GifMaker_Swift_Template
//
//  Created by 강선미 on 02/09/2019.
//  Copyright © 2019 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    var gif: Gif?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         shareButton.layer.cornerRadius = 4.0
        
        if let gifImage = gif?.gifImage {
            gifImageView.image = gifImage
        }
    }
 

    @IBAction func closeDetailVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareGif(_ sender: Any) {

        var itemsToShare = [NSData]()
        itemsToShare.append(gif!.gifData!)
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        present(activityVC, animated: true, completion: nil)
    }
    

}
