//
//  NewsCell.swift
//  TechNews
//
//  Created by Ruslan Akberov on 13/09/2019.
//  Copyright © 2019 Ruslan Akberov. All rights reserved.
//

import UIKit

protocol NewsCellDelegate: class {
    func showImage(url: String?)
}

class NewsCell: UITableViewCell {
    
    weak var delegate: NewsCellDelegate?
    private var imageUrl: String?
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let desctiptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .justified
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    let imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Image", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1.0)
        button.layer.cornerRadius = 4
        return button
    }()
    
    let redDotView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1, green: 59 / 255, blue: 48 / 255, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imageButton.addTarget(self, action: #selector(showImage), for: .touchUpInside)
        
        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(desctiptionLabel)
        stackView.addArrangedSubview(imageButton)
        
        contentView.addSubview(redDotView)
        redDotView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        redDotView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        redDotView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        redDotView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
    }
    
    func configureWith(title: String?, description: String?, imageUrl: String?) {
        titleLabel.text = title
        desctiptionLabel.text = description
        self.imageUrl = imageUrl
    }
    
    @objc func showImage() {
        delegate?.showImage(url: imageUrl)
    }
    
}
