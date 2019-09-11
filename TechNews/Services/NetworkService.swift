//
//  NetworkService.swift
//  TechNews
//
//  Created by Ruslan Akberov on 11/09/2019.
//  Copyright © 2019 Ruslan Akberov. All rights reserved.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    private let APIKey = "fc5efb82278a4d93b8b23753b874e35a"
    let baseUrl = URL(string: "https://newsapi.org/v2/top-headlines?category=technology&country=us")!
    
    func downloadNews(completion: @escaping ([News]?) -> Void) {
        var request = URLRequest(url: baseUrl)
        request.setValue(APIKey, forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let newsData = data else {
                completion(nil)
                return
            }
            
            if let articles = try? JSONDecoder().decode(Articles.self, from: newsData) {
                completion(articles.news)
            }
        }
        task.resume()
    }
    
}
