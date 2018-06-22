//
//  ThumbnailsViewModel.swift
//  FlickrApp
//
//  Created by melisadlg on 6/21/18.
//  Copyright © 2018 melisadlg. All rights reserved.
//

import Foundation

class ThumbnailViewModel {
   
    var imageCells = [ImageCell]()
    
    func getRecent(page forPage: Int, completion: @escaping (_ imageCells: [ImageCell]?, _ error: Error?) -> Void) {
        
        let baseURL = FlickrAPI.searchURL
        let apiString = "&api_key=\(FlickrAPI.key)"
        let searchTag = "&tags=amsterdam"
        let perPage = "&per_page=30"
        let page = "&page=" + String(describing: forPage)
        let responseFormat = "&format=json&nojsoncallback=1"
        
        let requestURL = URL(string: baseURL + apiString + searchTag + perPage + page + responseFormat)
        
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil, error)
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let dictionary = responseJSON as? [String: Any] {
                if let array = dictionary["photos"] as? [String: Any] {
                    if let photoArray = array["photo"] as? [Any] {
                        for case let object as [String: Any] in photoArray {
                            let photo = object
                            let newPhoto = Photo(json: photo)
                            
                            self.getPhotoInfo(forPhoto: (newPhoto?.photoID)!, completion: { (photoInfo, error) in
                                
                                let thumbnailItem = photoInfo?.first(where: { $0.label == "Small" })
                                let imageURL = thumbnailItem?.source
                                
                                let newImageCell = ImageCell(imageURL: imageURL!, title: (newPhoto?.title)!, photoInfo: photoInfo!)
                                self.imageCells.append(newImageCell)
                                if self.imageCells.count == (forPage * 30) {
                                    completion(self.imageCells, nil)
                                }
                            })
                        }
                    }
                }
            }
        }.resume()
    }
    
    func getPhotoInfo(forPhoto photoID: String, completion: @escaping (_ photoInfo: [PhotoInfo]?, _ error: Error?) -> Void) {
        
        let baseURL = FlickrAPI.infoURL
        let apiString = "&api_key=\(FlickrAPI.key)"
        let photoID = "&photo_id=\(String(describing: photoID))"
        let responseFormat = "&format=json&nojsoncallback=1"
        
        let requestURL = URL(string: baseURL + apiString + photoID + responseFormat)
        
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil, error)
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            var photoInfo = [PhotoInfo]()
            
            if let dictionary = responseJSON as? [String: Any] {
                if let array = dictionary["sizes"] as? [String: Any] {
                    if let photoArray = array["size"] as? [Any] {
                        for case let object as [String: Any] in photoArray {
                            let newPhotoInfo = PhotoInfo(json: object)
                            photoInfo.append(newPhotoInfo!)
                        }
                        
                    }
                    
                }
            }
            completion(photoInfo, nil)
            }.resume()
    }
    
}
