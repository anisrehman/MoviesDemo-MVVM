//
//  MovieDetailsViewModel.swift
//  MoviesDemo-MVVM
//
//  Created by Anis Rehman on 08/11/2022.
//

import Foundation
import Combine

class MovieDetailsViewModel {
    @Published var title: String = ""
    @Published var imagePath: String = ""
    @Published var ratingFormatted: String = ""
    @Published var description: String = ""

    var movie: Movie!

    init(movie: Movie) {
        self.movie = movie
    }

    func getMovieDetails() {
        self.title = movie.title
        self.imagePath = movie.posterPath ?? ""
        self.ratingFormatted = "Rating: \(movie.voteAverage)"
        self.description = movie.overview
    }
}
