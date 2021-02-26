//
//  ImageView.swift
//  MovieDB
//
//  Created by Macbook Air on 2/26/21.
//

import UIKit

class ImageView: UIImageView {
    
    
    
    func fetchImage(with url: String?) {
        guard let url = url else {return}
        guard let imageUrl = URL(string: url) else {
            image = UIImage(systemName: "nosign")
            return
        }
        
        //Download from cach
        if let cachedImage = getCachedImage(url: imageUrl) {
            image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let error = error {print(error.localizedDescription); return}
            guard let data = data, let response = response else {return}
            guard let responseUrl = response.url else {return}
            
            if responseUrl.absoluteString != url {return}
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            
            self.saveImageToCached(data: data, response: response)
            
        }.resume()
        
    }
    
    private func saveImageToCached(data: Data, response: URLResponse) {
        guard let responseURL = response.url else {return}
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
    
    private func getCachedImage(url: URL) -> UIImage? {
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
}
