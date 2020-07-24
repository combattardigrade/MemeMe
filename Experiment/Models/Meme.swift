//
//  Meme.swift
//  Experiment
//
//  Created by tardigrade on 21/07/20.
//  Copyright © 2020 tardigrade. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
