//
//  FullscreenCollectionViewCell.swift
//  FlickrApp
//
//  Created by melisadlg on 6/21/18.
//  Copyright © 2018 melisadlg. All rights reserved.
//

import UIKit

class FullscreenCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var image:UIImage? {
        didSet {
            configureForNewImage(animated: false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureForNewImage(animated: Bool = true) {
        imageView.image = image
        imageView.sizeToFit()
        
        if animated {
            imageView.alpha = 0.0
            UIView.animate(withDuration: 0.5) {
                self.imageView.alpha = 1.0
            }
        }
    }
}
