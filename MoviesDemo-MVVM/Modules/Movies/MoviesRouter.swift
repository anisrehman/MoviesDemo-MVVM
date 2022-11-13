//
//  MoviesRouter.swift
//  MoviesDemo
//
//  Created Anis Rehman on 11/02/2020.
//  Copyright © 2020 Anis ur Rehman. All rights reserved.
//
//

import UIKit

protocol MoviesRoutable: AnyObject {
    init(navigationController: UINavigationController?)
    func routeToMovieDetails(movie: Movie)
}

class MoviesRouter: MoviesRoutable {
    var navigationController: UINavigationController?
    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func routeToMovieDetails(movie: Movie) {
        let viewModel = MovieDetailsViewModel(movie: movie)

        let storyBoard = UIStoryboard(name: Storyboard.main.rawValue, bundle: nil)
        let movieDetailsViewController = storyBoard.instantiateViewController(identifier: StoryboardID.movieDetailsViewController.rawValue) as! MovieDetailsViewController
        movieDetailsViewController.viewModel = viewModel

        movieDetailsViewController.title = "Movie Details"
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}
