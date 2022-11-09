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
    init(navigationController: @escaping () -> UINavigationController?)
    func routeToMovieDetails(movie: Movie)
}

class MoviesRouter: MoviesRoutable {
    // To avoid circular reference, use a closure that gets UINavigationController
    // It will help us to avoid weak circular reference
    var getNavigationController: () -> UINavigationController?
    required init(navigationController: @escaping () -> UINavigationController?) {
        self.getNavigationController = navigationController
    }

    func routeToMovieDetails(movie: Movie) {
        let viewModel = MovieDetailsViewModel(movie: movie)

        let storyBoard = UIStoryboard(name: Storyboard.main.rawValue, bundle: nil)
        let movieDetailsViewController = storyBoard.instantiateViewController(identifier: StoryboardID.movieDetailsViewController.rawValue) as! MovieDetailsViewController
        movieDetailsViewController.title = "Movie Details"
        movieDetailsViewController.viewModel = viewModel
        getNavigationController()?.pushViewController(movieDetailsViewController, animated: true)
    }
}
