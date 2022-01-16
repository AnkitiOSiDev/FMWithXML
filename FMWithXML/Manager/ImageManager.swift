//
//  ImageManager.swift
//  FMWithXML
//
//  Created by Ankit on 17/01/22.
//

import UIKit

extension UIImageView {
    public func imageFromServerURL(url: URL,placeholderImage: UIImage?) {
        
        
        if let image = ImageCache.image(url: url as NSURL) {
            self.image = image
            return
        }
        
        if  self.image == nil {
            self.image = placeholderImage
        }
        
        DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.image = image
                                ImageCache.addImage(image: image, url: url as NSURL)
                            }
                        }
                    }
        }
}}


class ImageCache {
    static private let cachedImages = NSCache<NSURL, UIImage>()
    
    static func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    static func addImage(image:UIImage,url: NSURL) {
        self.cachedImages.setObject(image, forKey: url)
    }
   
}
