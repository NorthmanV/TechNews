//
//  MainVC.swift
//  TechNews
//
//  Created by Ruslan Akberov on 11/09/2019.
//  Copyright © 2019 Ruslan Akberov. All rights reserved.
//

import UIKit

class MainVC: UITableViewController {
    
    private var news = [News]()
    private let newsCellId = "newsCellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        NetworkService.shared.downloadNews { news in
            if let news = news {
                self.news = news
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Tech News"
        tableView.register(NewsCell.self, forCellReuseIdentifier: newsCellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellId, for: indexPath) as! NewsCell
        cell.delegate = self
        let specificNews = news[indexPath.row]
        cell.configureWith(title: specificNews.title, description: specificNews.description, imageUrl: specificNews.imageUrl)
        return cell
    }

}

extension MainVC: NewsCellDelegate {
    
    func showImage(url: String?) {
        let newsImageVC = NewsImageVC()
        newsImageVC.imageUrl = url
        navigationController?.pushViewController(newsImageVC, animated: true)
    }
    
}

