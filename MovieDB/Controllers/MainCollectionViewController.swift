//
//  MainCollectionViewController.swift
//  MovieDB
//
//  Created by Macbook Air on 2/25/21.
//

import UIKit

protocol IsLikeDelegate: class {
    func update(_ object: Result)
}

class MainCollectionViewController: UICollectionViewController {

    var movieModel = [Result]()
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCV()
        fetchMovie()
        
    }
    
    private func fetchMovie() {
        networkManager.fetchCurrentMovie {[weak self] (movie) in
            self?.movieModel = movie
            print(movie)
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    

    private func configureCV() {
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetail = movieModel[indexPath.item]
        guard let detailVC = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else {return}
        detailVC.movie = movieDetail
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movieModel.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
    
        let movie = movieModel[indexPath.item]
        cell.configure(with: movie)
        cell.delegate = self
        return cell
    }

    // MARK: UICollectionViewDelegate

}

extension MainCollectionViewController: IsLikeDelegate {
    func update(_ object: Result) {
        guard let id = object.id else {
            return
        }
        
        for (index, value) in movieModel.enumerated() where value.id == id {
            movieModel[index] = object
        }
        
        collectionView.reloadData()
    }
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let leftRightPadding: CGFloat = 24
        let spaces:CGFloat = 45
        let cellWidth = (screenWidth - leftRightPadding - spaces)
        return CGSize(width: cellWidth , height: cellWidth)    }
}
