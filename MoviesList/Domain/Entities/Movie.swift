import Foundation

struct OMDBMoviesPage: Equatable {
    let totalResult: Int
    let movies: [MovieItem]
}
