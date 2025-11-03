//
//  UIImageView+Extensionsswift.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 31.10.2025.
//

import UIKit

extension UIImageView {
    func load(with urlString: String) {
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
        }
    }
}
