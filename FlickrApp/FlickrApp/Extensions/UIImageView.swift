//
//  UIImage.swift
//  FlickrApp
//
//  Created by melisadlg on 6/20/18.
//  Copyright © 2018 melisadlg. All rights reserved.
//

import UIKit

extension UIImageView {

    
    internal func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    public func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
    
    public func getImageHeight() -> CGFloat {
        if self.image != nil {
            return (self.image?.size.height)!
        } else {
            return 200
        }
        
    }
    
}
