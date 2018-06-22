//
//  CustomCollectionViewCell.swift
//  FlickrApp
//
//  Created by melisadlg on 6/20/18.
//  Copyright © 2018 melisadlg. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    public var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
