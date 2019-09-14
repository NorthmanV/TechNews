//
//  NetworkService.swift
//  TechNews
//
//  Created by Ruslan Akberov on 11/09/2019.
//  Copyright © 2019 Ruslan Akberov. All rights reserved.
//

import UIKit

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    private let APIKey = "fc5efb82278a4d93b8b23753b874e35a"
    private let baseUrl = URL(string: "https://newsapi.org/v2/top-headlines?category=technology&country=us")!
    
    func downloadNews(completion: @escaping ([News]?) -> Void) {
        var request = URLRequest(url: baseUrl)
        request.setValue(APIKey, forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let newsData = data else {
                completion(nil)
                return
            }
            
            if let articles = try? JSONDecoder().decode(Articles.self, from: newsData) {
                DispatchQueue.main.async { completion(articles.news) }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func downloadImage(url: String?, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: url ?? "") else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard error == nil, let imageData = data else {
                completion(nil)
                return
            }
            DispatchQueue.main.async { completion(UIImage(data: imageData)) }
        }
        task.resume()
    }
    
}
