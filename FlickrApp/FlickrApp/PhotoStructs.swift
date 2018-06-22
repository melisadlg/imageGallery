//
//  PhotoStructs.swift
//  FlickrApp
//
//  Created by melisadlg on 6/21/18.
//  Copyright © 2018 melisadlg. All rights reserved.
//

import Foundation

struct ImageCell {
    var imageURL: String
    var title: String
    var photoInfo: [PhotoInfo]
    
    init(imageURL: String, title: String, photoInfo: [PhotoInfo]) {
        self.imageURL = imageURL
        self.title = title
        self.photoInfo = photoInfo
    }
}

struct Photo: Codable {
    var farmID: Int
    var serverID: String
    var photoID: String
    var secret: String
    var title: String
    
    init?(json: [String: Any]) {
        guard let farmID = json["farm"] as? Int,
            let serverID = json["server"] as? String,
            let photoID = json["id"] as? String,
            let secret = json["secret"] as? String,
            let title = json["title"] as? String else {
                return nil
        }
        self.farmID = farmID
        self.serverID = serverID
        self.photoID = photoID
        self.secret = secret
        self.title = title
    }
}

struct PhotoInfo: Codable {
    var label: String
    var height: String
    var width: String
    var source: String
    
    init?(json: [String: Any]) {
        guard let label = json["label"] as? String,
            let source = json["source"] as? String else {
                return nil
        }
        var jsonHeight = ""
        if let heightString = json["height"] as? String {
            jsonHeight = heightString
        } else if let heightInt = json["height"] as? Int{
            jsonHeight = String(describing: heightInt)
        }
        
        var jsonWidth = ""
        if let widthString = json["width"] as? String {
            jsonWidth = widthString
        } else if let widthInt = json["width"] as? Int{
            jsonWidth = String(describing: widthInt)
        }
        
        self.label = label
        self.source = source
        self.height = jsonHeight
        self.width = jsonWidth
    }
}
