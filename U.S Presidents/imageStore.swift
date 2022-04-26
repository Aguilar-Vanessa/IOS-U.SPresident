//
//  imageStore.swift
//  U.S Presidents
//
//  Created by Vanessa Aguilar on 11/17/20.
//  Copyright © 2020 Personal Team. All rights reserved.
//

///Class that provides data from web
import Foundation
import UIKit

class  ImageStore{
    //creating a cache for the images so they do not have to be downloaded
        //if memory gets low it starts throwing the cache away
    let imageCache = NSCache<NSString, AnyObject>()
    
    //Function with passed in url String
    func downloadImage(with urlString: String, completion: @escaping ( _ image: UIImage?) -> Void){
            
        //Default image, just in case we have an image we cannot download
        if urlString == "None"{
            completion(UIImage(named: "default.png"))
        }else if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage{
            completion(cachedImage) //using the default image if you cant download
        }else{
            //if the ? gives us false aka it didnt work this code will be executed
                weak var weakSelf = self
            if let url = URL(string: urlString){ //trying to convert that string into an actual urlstring
            
                
                   let task = URLSession.shared.dataTask(with: url) {
                       (data, response, error) in
                       
                   let httpResponse = response as? HTTPURLResponse
                    
                   if httpResponse!.statusCode != 200 {
                   // Perform some error handling
                   // UI updates, like alerts, should be directed to the main thread
                        DispatchQueue.main.async {
                            print( "HTTP Error: status code \(httpResponse!.statusCode)")
                            completion(UIImage(named: "default.png"))
                        }
                   }else if (data == nil && error != nil) {
                               // Perform some error handling
                                    DispatchQueue.main.async {
                                              print( "No data downloaded for \(urlString)")
                                              completion(UIImage(named: "default.png"))
                                          }
                   } else {
                   // Download succeded, will put the things into the objects succesfully
                        if let image = UIImage(data: data!){ //tries to take binary data and convert it into an image
                                    DispatchQueue.main.async {
                                        weakSelf!.imageCache.setObject(image, forKey: urlString as NSString)
                                        completion(image)
                                    }
                        }else{ //Not a valid image
                            DispatchQueue.main.async {
                                print( "\(urlString) is not a valid image")
                                completion(UIImage(named: "default.png"))
                            }
                        }
                    }
               }
                   task.resume()
            }else{
                        DispatchQueue.main.async {
                            print( "\(urlString) is not a valid URL")
                            completion(UIImage(named: "default.png"))
                        }
            }
        }
    }
    
    func clearCache(){
        imageCache.removeAllObjects()
    }
}
