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
    
    private let APIKey = "feb17943bff24c4ba29db88d0979907b"
    private let baseUrl = URL(string: "https://newsapi.org/v2/top-headlines")!
    
    func downloadNews(page: Int, completion: @escaping ([News]?) -> Void) {
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        let queryCategory = URLQueryItem(name: "category", value: "technology")
        let queryCountry = URLQueryItem(name: "country", value: "us")
        let queryPage = URLQueryItem(name: "page", value: String(page))
        components.queryItems = [queryCategory, queryCountry, queryPage]
        let url = components.url!
        var request = URLRequest(url: url)
        request.setValue(APIKey, forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let newsData = data else {
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context!] = DataService.shared.context
            if let articles = try? decoder.decode(Articles.self, from: newsData) {
                completion(articles.news) 
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
