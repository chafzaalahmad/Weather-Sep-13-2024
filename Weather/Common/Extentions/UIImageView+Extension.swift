//
//  UIImageView+Extension.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import UIKit

extension UIImageView {
    func loadImage(with url: URL) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        self.image = downloadedImage
                    }
                }
            }
        }).resume()
    }
}

