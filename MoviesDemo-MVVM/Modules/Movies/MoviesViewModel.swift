//
//  MoviesViewModel.swift
//  MoviesDemo-MVVM
//
//  Created by Anis Rehman on 01/11/2022.
//

import Foundation
import Combine

class MoviesViewModel {
    @Published var movies = []

    var moviesService = MoviesService()

    func fetchMovies(_ category: Category) {
        moviesService.fetchMovies(category) { [weak self] movies, error in
            guard let weakSelf = self else { return }
            let movieRepository = DependencyContainer.shared.get(MovieStoring.self)
            if let movies {
                movieRepository?.resetMovies(movies, category: category)
                self?.movies = movies
            } else if error != nil {
                let movies = weakSelf.moviesFromDB(category: category)
                self?.movies = movies
            }
        }
    }

    private func moviesFromDB(category: Category) -> [Movie] {
        let movieRepository = DependencyContainer.shared.get(MovieStoring.self)
        let movies = movieRepository?.allMovies(category: category) ?? []
        return movies
    }
}
