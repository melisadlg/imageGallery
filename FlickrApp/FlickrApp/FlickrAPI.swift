//
//  File.swift
//  FlickrApp
//
//  Created by melisadlg on 6/20/18.
//  Copyright © 2018 melisadlg. All rights reserved.
//

import Foundation

public struct FlickrAPI {
    
    public static let key        = "0a156034359815ccab83d0319e8fe726"
    public static let secret     = "24d5164effae2395"

    public static let baseURL    = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent"
    public static let searchURL  = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
    public static let infoURL = "https://api.flickr.com/services/rest/?method=flickr.photos.getSizes"
}
