import Foundation

protocol MoviesRepository {
    @discardableResult
    func getMoviesList(query: MovieQuery, page: Int,
        completion: @escaping (Result<OMDBMoviesPage, Error>) -> Void
    ) -> Cancellable?
}
