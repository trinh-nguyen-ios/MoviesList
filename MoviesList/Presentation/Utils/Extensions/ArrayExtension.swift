//
//  ArrayExtension.swift
//  MoviesList
//
//  Created by Nguyen The Trinh on 3/19/23.
//

import Foundation

extension Array where Element == OMDBMoviesPage {
    var movies: [MovieItem] { flatMap { $0.movies } }
}
