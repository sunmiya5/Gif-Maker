//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by 강선미 on 03/09/2019.
//  Copyright © 2019 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif: NSObject, NSCoding {
    
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
    

    public required init?(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObject(forKey: "url") as? URL
        self.videoURL = aDecoder.decodeObject(forKey: "videoURL") as? URL
        self.caption = aDecoder.decodeObject(forKey: "caption") as? String
        self.gifImage = aDecoder.decodeObject(forKey: "gifImage") as? UIImage
        self.gifData = aDecoder.decodeObject(forKey: "gifData") as? NSData
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.videoURL, forKey: "videoURL")
        aCoder.encode(self.caption, forKey: "caption")
        aCoder.encode(self.gifImage, forKey: "gifImage")
        aCoder.encode(self.gifData, forKey: "gifData")
    }

}
