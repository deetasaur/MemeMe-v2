//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Aditya Ramayanam on 10/14/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var memedImage: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.memedImage!.image = meme.memeImage
    }
}
