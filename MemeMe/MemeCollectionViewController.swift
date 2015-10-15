//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Aditya Ramayanam on 10/9/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewController : UICollectionViewController {
    
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
        // Manually reload the collection data every time the user switches to the collection view
        collectionView?.reloadData()
        
        // Collection layout spacing and size
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Setting the collection view cell to the meme image
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.memedImage.image = meme.memeImage
        
        /*
        let meme = memes[indexPath.item]
        cell.setText(meme.top, bottomString: meme.bottom)
        let imageView = UIImageView(image: meme.image)
        cell.backgroundView = imageView
        */
        
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
