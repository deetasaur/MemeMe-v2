//
//  Meme.swift
//  MemeMe
//
//  Created by Aditya Ramayanam on 9/25/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    var topText: String = ""
    var bottomText: String = ""
    var origImage: UIImage
    var memeImage: UIImage
    
    init(top: String, bottom: String, image: UIImage, memedImage: UIImage) {
        self.topText = top
        self.bottomText = bottom
        self.origImage = image
        self.memeImage = memedImage
    }
    
    func getMemedImage() -> UIImage {
        return memeImage
    }
    
}