//
//  UIImageView+Extensionsswift.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 31.10.2025.
//

import UIKit

extension UIImageView {
    func load(with urlString: String) {
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let safeFileName = urlString.replacingOccurrences(of: "[^a-zA-Z0-9]", with: "_", options: .regularExpression)
        let fileUrl = documents.appendingPathComponent(safeFileName + ".png")
//        if let cachedImage = ImageCache.shared.object(forKey: urlString as NSString) {
//            self.image = cachedImage
//            print("Used Cached Image")
//            return
//        }
        if FileManager.default.fileExists(atPath: fileUrl.path),
           let image = UIImage(contentsOfFile: fileUrl.path) {
            self.image = image
            print("Used Cached Image from File Manager")
            return
            }
        Task{
            guard let url = URL(string: urlString) else {
                self.image = UIImage(systemName: "photo")
                return
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.image = UIImage(systemName: "photo")
                return
            }
            guard let image = UIImage(data: data) else {
                self.image = UIImage(systemName: "photo")
                return
            }
            self.image = image
            
            //ImageCache.shared.setObject(image, forKey: urlString as NSString)
            
            if let data = image.pngData(){
                do{
                    try data.write(to: fileUrl)
                    print("Image downloaded")
                }catch{
                    print("Unable to save image")
                }
            }
        }
    }
}
