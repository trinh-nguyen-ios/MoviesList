//
//  MoviesItemViewModel.swift
//  MoviesList
//
//  Created by Nguyen The Trinh on 3/18/23.
//

struct MovieItemViewModel {
    let title: String
    let imagePath: String
    
}

extension MovieItemViewModel {

    init(movie: MovieItem) {
        self.title = movie.title
        self.imagePath = movie.poster
    }
}
