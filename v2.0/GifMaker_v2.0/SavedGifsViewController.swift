//
//  SavedGifsViewController.swift
//  GifMaker_v2.0
//
//  Created by 강선미 on 17/09/2019.
//  Copyright © 2019 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController, UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var savedGifs = [Gif]()
    let cellMargin:CGFloat = 12.0

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIStackView!
    
    var gifsFilePath: String {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsPath = directories[0]
        let gifsPath = documentsPath.appending("/savedGifs")
        return gifsPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showWelcome()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let unarchivedGifs = NSKeyedUnarchiver.unarchiveObject(withFile: gifsFilePath) as? [Gif] {
            savedGifs = unarchivedGifs
        }
        // Do any additional setup after loading the view.
    }
    
    func showWelcome() {
        
        if !(UserDefaults.standard.bool(forKey: "WelcomeViewSeen")) {
            let welcomeVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         emptyView.isHidden = (savedGifs.count != 0)
         collectionView.reloadData()
    }
    
    // MARK: CollectionView Delegate and Datasource Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = savedGifs[indexPath.item]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.gif = gif
        detailVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(detailVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        let gif = savedGifs[indexPath.item]
        cell.configureForGif(gif: gif)
        return cell
    }
    
    // MARK: CollectionViewFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  (collectionView.frame.size.width - (cellMargin * 2.0))/2.0
        return CGSize(width: width, height: width)
    }

}

extension SavedGifsViewController : PreviewViewControllerDelegate {
    // MARK: PreviewControllerDelegate Method
    
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif) {
        print("previewVC called")
        gif.gifData = NSData(contentsOf: gif.url!)
        self.savedGifs.append(gif)
        NSKeyedArchiver.archiveRootObject(self.savedGifs, toFile: self.gifsFilePath)
    }
}
