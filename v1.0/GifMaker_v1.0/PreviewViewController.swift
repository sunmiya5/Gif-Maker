//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by 강선미 on 02/09/2019.
//  Copyright © 2019 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var gifImageView: UIImageView!
    var gif: Gif?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let gifImage = gif?.gifImage {
           gifImageView.image = gifImage
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareGif(_ sender: Any) {
        
        let url: NSURL = (self.gif?.url)! as NSURL
        let animatedGIF = NSData(contentsOf: url as URL)!
        let itemsToShare = [animatedGIF]
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        navigationController?.present(activityVC, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
