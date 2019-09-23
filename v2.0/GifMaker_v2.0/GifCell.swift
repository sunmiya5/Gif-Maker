//
//  GifCell.swift
//  GifMaker_v2.0
//
//  Created by 강선미 on 17/09/2019.
//  Copyright © 2019 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    func configureForGif(gif: Gif) {
        gifImageView.image = gif.gifImage
    }
}
