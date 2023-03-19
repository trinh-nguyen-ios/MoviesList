//
//  MovieItemCell.swift
//  MoviesList
//
//  Created by Nguyen The Trinh on 3/18/23.
//

import UIKit

class MovieItemCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(_ model: MovieItemViewModel) {
        titleLabel.text = model.title
        imageView.image = UIImage(named: "film")
        if let url = URL(string: model.imagePath) {
            imageView.downloaded(from: url, contentMode: .scaleAspectFill)
        } else {
            imageView.image = UIImage(named: "film")
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "film")
        imageView.contentMode = .scaleAspectFill
    }
}
