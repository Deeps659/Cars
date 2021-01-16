//
//  UIImage.swift
//  CARS
//
//  Created by DEEPALI MAHESHWARI on 28/12/20.
//  Copyright © 2020 DEEPALI MAHESHWARI. All rights reserved.
//

import UIKit

private let imageCache = NSCache<AnyObject, AnyObject>()
private let networkManager = NetworkManager(session: URLSession.shared)

extension UIImageView {

    func addEffectOnBottom()
    {
        let frame = self.bounds
        let newFrame = CGRect(x: frame.minX, y: frame.height * 0.80, width: frame.width, height: frame.height)
        let otherView = UIView(frame: newFrame)
        otherView.backgroundColor = UIColor.black
        otherView.alpha =  0.6
        self.addSubview(otherView)
    }
    
    /// This loadImage function is used to download image using urlString
    /// This method also using cache of loaded image using urlString as a key of cached image.
    func loadImage(urlSting: String) {
        guard let url = URL(string: urlSting) else { return }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        
        networkManager.loadData(url: url) { [weak self] result in
            switch result {
                case .success(let data):
                    guard let imageToCache = UIImage(data: data) else { return }
                    imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: data)
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.image = UIImage(named: "noImage")
                    }
            }
        }
    }
}
