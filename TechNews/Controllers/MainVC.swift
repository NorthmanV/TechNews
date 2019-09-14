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
    private var currentRequestPage = 1
    private var shouldLoad = false
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        downloadNews()
    }
    
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Tech News"
        tableView.register(NewsCell.self, forCellReuseIdentifier: newsCellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height:20))
        footerView.backgroundColor = .clear
        footerView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        tableView.tableFooterView = footerView
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        
        if let fetchedNews = DataService.shared.fetchNews() {
            news = fetchedNews
        }
    }
    
    private func downloadNews() {
        NetworkService.shared.downloadNews(page: currentRequestPage) { news in
            if let _ = news {
                DataService.shared.saveContext()
                let fetchedNews = DataService.shared.fetchNews()
                self.news = fetchedNews ?? [News]()
                DispatchQueue.main.async {
                    if self.refreshControl!.isRefreshing {
                        self.refreshControl!.endRefreshing()
                    }
                    self.tableView.reloadData()
                    self.currentRequestPage += 1
                    self.shouldLoad = true
                }
            }
            DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellId, for: indexPath) as! NewsCell
        cell.delegate = self
        let specificNews = news[indexPath.row]
        cell.configureWith(title: specificNews.title, description: specificNews.descr, imageUrl: specificNews.imageUrl)
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.frame.height
        
        if offsetY > contentHeight - scrollHeight && shouldLoad {
            shouldLoad = false
            activityIndicator.startAnimating()
            downloadNews()
        }
    }
    
    @objc func refreshNews() {
        currentRequestPage = 1
        downloadNews()
    }

}

extension MainVC: NewsCellDelegate {
    
    func showImage(url: String?) {
        let newsImageVC = NewsImageVC()
        newsImageVC.imageUrl = url
        navigationController?.pushViewController(newsImageVC, animated: true)
    }
    
}

