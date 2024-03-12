//
//  SearchResultsViewControllerCell.swift
//  VIPERTest
//
//  Created by Elena Lucher on 07.03.2024.
//

import Foundation
import UIKit

class SearchResultsViewControllerCell: UICollectionViewCell {
    
    static var reuseID = String(describing: SearchResultsViewControllerCell.self)
    /// The original link works as ID for the data this cell is presenting.
    var representedIdentifier: String?
    let imageLoader = ImageLoader()

    private var imageView = UIImageView()
    private let activity = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: Public methods
    func configure(for image: ImagesResult?) {
        representedIdentifier = image?.identifier
        if let image, let url = URL(string: image.thumbnail) {
            Task {
                imageView.image = try await imageLoader.downloadImage(from: url)
                activity.stopAnimating()
            }
        }
    }
    
}

// MARK: SetupViewProtocol
extension SearchResultsViewControllerCell {
    
    func setupViews() {
        setupSelf()
        setupImageView()
        setupActivityIndicator()
    }
    
    func setupSelf() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.borderWidth = 0.5
        layer.borderColor = CGColor.init(gray: 0.5, alpha: 1)
        clipsToBounds = true
    }
    
    func setupImageView() {
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupActivityIndicator() {
        activity.color = .systemMint
        addSubview(activity)
        activity.center = center
        activity.startAnimating()
    }
}

