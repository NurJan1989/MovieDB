//
//  MovieCollectionViewCell.swift
//  MovieDB
//
//  Created by Macbook Air on 2/25/21.
//

import UIKit



class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: ImageView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var realeseDateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: IsLikeDelegate?
    private var object: Result?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setupUI() {
        
        [voteAverageLabel, likeButton].forEach {
            $0?.layer.cornerRadius = $0!.frame.size.width / 2
            $0?.clipsToBounds = true
        }
        
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
    }
    
    func configure(with movie: Result) {
        self.object = movie
        
        titleLabel.text = movie.title
        realeseDateLabel.text = movie.releaseDate
        voteAverageLabel.text = String(movie.voteAverage ?? 0)
        imageView.fetchImage(with: movie.bestUrl)

        likeButton.setImage(movie.isSelected ? UIImage(named: "like") : UIImage(named: "unlike"), for: .normal)
    }
    
    @IBAction func handleLikeButton(_ sender: UIButton) {
        guard var object = object else {
            return
        }
        object.isSelected = !object.isSelected
        delegate?.update(object)
    }
}


