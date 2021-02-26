//
//  DetailViewController.swift
//  MovieDB
//
//  Created by Macbook Air on 2/25/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var movie: Result?
    weak var delegate: IsLikeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        setupUI()
    }
    
    private func setupUI() {
        
        [titleLabel, releaseDateLabel].forEach {
            $0?.layer.cornerRadius = 5
            $0?.clipsToBounds = true
        }
        
        [voteAverageLabel, likeButton].forEach {
            $0?.layer.cornerRadius = $0!.frame.size.width / 2
            $0?.clipsToBounds = true
        }
        
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
    }
    
    private func configureVC() {
        guard let titleMovie = movie?.title,
              let voteAverage = movie?.voteAverage,
              let releaseDate = movie?.releaseDate,
              let overview = movie?.overview,
              let movieURL = movie?.bestUrl
        else {return}
        
        title = titleMovie
        voteAverageLabel.text = voteAverage.description
        titleLabel.text = titleMovie
        releaseDateLabel.text = releaseDate
        descriptionLabel.text = overview
        
        DispatchQueue.global().async {
            guard let urlImage = URL(string: movieURL) else {return}
            guard let imageData =  try? Data(contentsOf: urlImage) else {return}
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
        }
        
        if let isSelected = movie?.isSelected {
            likeButton.setImage(isSelected ? UIImage(named: "like") : UIImage(named: "unlike"), for: .normal)
        }
    }
    
    @IBAction func handleLikeButton() {
        guard var object = movie else {
            return
        }
        object.isSelected = !object.isSelected
        likeButton.setImage(object.isSelected ? UIImage(named: "like") : UIImage(named: "unlike"), for: .normal)
        delegate?.update(object)
    }
}
