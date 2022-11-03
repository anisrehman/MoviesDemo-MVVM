//
//  MoviesViewModel.swift
//  MoviesDemo-MVVM
//
//  Created by Anis Rehman on 01/11/2022.
//

import Foundation
import Combine

class MoviesViewModel {
    @Published var movies: [Movie] = []

    var moviesService = MoviesService()

    init() {
        DependencyContainer.shared.register(type: MovieStoring.self, value: MovieRepository(), overwrite: false)
    }
    
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

    func searchMovies(text: String, category: Category) {
        let movieRepository = DependencyContainer.shared.get(MovieStoring.self)
        movies = movieRepository?.searchMovies(text: text, category: category) ?? []
    }

    func clearSearch(category: Category) {
        let movies = moviesFromDB(category: category)
        self.movies = movies
    }

    private func moviesFromDB(category: Category) -> [Movie] {
        let movieRepository = DependencyContainer.shared.get(MovieStoring.self)
        let movies = movieRepository?.allMovies(category: category) ?? []
        return movies
    }
}
