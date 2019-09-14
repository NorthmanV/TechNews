//
//  NewsImageVC.swift
//  TechNews
//
//  Created by Ruslan Akberov on 14/09/2019.
//  Copyright © 2019 Ruslan Akberov. All rights reserved.
//

import UIKit

class NewsImageVC: UIViewController {
    
    var imageUrl: String?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        downloadImge()
    }

    private func setupViews() {
        navigationItem.largeTitleDisplayMode = .never
        title = "News Image"
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        imageView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(scaleImage)))
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    private func downloadImge() {
        NetworkService.shared.downloadImage(url: imageUrl) { image in
            DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
            if let image = image {
                self.imageView.image = image
            } else {
                self.showDefaultAlertError()
            }
        }
    }
    
     @objc func scaleImage(sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
            sender.scale = 1.0
        }
    }
    
}
