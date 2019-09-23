//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by 강선미 on 03/09/2019.
//  Copyright © 2019 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif {
    
    let url: URL?
    let videoURL: URL?
    var caption: String?
    var gifImage: UIImage?
    var gifData: NSData?
    
    init(url:URL, rawVideoURL: URL, caption: String?, name: String?) {
    
      self.url = url 
      self.videoURL = rawVideoURL
      self.caption = caption
      self.gifImage = UIImage.gif(url: url.absoluteString)
      self.gifData = nil
      //self.gifImage = UIImage.gif(name: name!)
    }

}
