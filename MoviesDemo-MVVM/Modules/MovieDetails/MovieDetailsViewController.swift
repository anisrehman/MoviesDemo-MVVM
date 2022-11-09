//
//  MovieDetailsViewController.swift
//  MoviesDemo
//
//  Created Anis Rehman on 13/02/2020.
//  Copyright © 2020 Anis ur Rehman. All rights reserved.
//
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController  {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    var viewModel: MovieDetailsViewModel!
    private var subscribers: [AnyCancellable] = []
	override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        viewModel.getMovieDetails()
    }
}

// MARK: - Private Functions
extension MovieDetailsViewController {
    func setup() {
        viewModel.$title.sink { [weak self] title in
            self?.titleLabel.text = title
        }.store(in: &subscribers)

        viewModel.$imagePath.sink { [weak self] imagePath in
            let imageURLString = Constants.mediumImageBaseURL + imagePath
            self?.posterImageView.setImage(from: imageURLString)
        }.store(in: &subscribers)

        viewModel.$description.sink { [weak self] description in
            self?.overviewLabel.text = description
        }.store(in: &subscribers)

        viewModel.$ratingFormatted.sink { [weak self] ratingText in
            self?.ratingLabel.text = ratingText
        }.store(in: &subscribers)
    }
}
