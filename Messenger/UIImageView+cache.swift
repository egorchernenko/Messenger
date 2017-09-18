//
//  UIImageView+cache.swift
//  Messenger
//
//  Created by Egor on 18.09.17.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadImageUsingCache(with stringUrl: String){
        
        //to avoid delay when reuse cell
        self.image = nil
        
        //check cache for image first
        if let cacheImage = imageCache.object(forKey: stringUrl as AnyObject) as? UIImage{
            self.image = cacheImage
            return
        }
        
        if let url = URL(string: stringUrl){
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data , response, error) in
                
                if let err = error{
                    print(err.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    
                    if let downloadedData = data{
                        if let dowloadedImage = UIImage(data: downloadedData){
                            imageCache.setObject(dowloadedImage, forKey: stringUrl as AnyObject)
                            self.image = dowloadedImage
                        }
                    } 
                    
                    
                }
                
            }).resume()
            
        }
    }
}
