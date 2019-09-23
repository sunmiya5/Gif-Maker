//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by 강선미 on 02/09/2019.
//  Copyright © 2019 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import MobileCoreServices

class WelcomeViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
        let proofOfConcept = UIImage.gif(name: "yeri")
        gifImageView.image = proofOfConcept
        
        UserDefaults.standard.set(true, forKey: "WelcomeViewSeen")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dispose of any resources that can be recreated
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
