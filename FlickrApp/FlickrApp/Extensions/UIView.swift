//
//  UIView.swift
//  FlickrApp
//
//  Created by melisadlg on 6/22/18.
//  Copyright © 2018 melisadlg. All rights reserved.
//

import UIKit

public extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}
