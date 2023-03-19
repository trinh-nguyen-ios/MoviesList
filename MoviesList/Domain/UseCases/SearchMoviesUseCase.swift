import Foundation

protocol SearchMoviesUseCase {
    @discardableResult
    func getMovies(requestValue: SearchOMDBMoviesUseCaseRequestValue, completion: @escaping (Result<OMDBMoviesPage, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {

    private let moviesRepository: MoviesRepository

    init( moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    @discardableResult
    func getMovies(requestValue: SearchOMDBMoviesUseCaseRequestValue,
                   completion: @escaping (Result<OMDBMoviesPage, Error>) -> Void) -> Cancellable? {
        return moviesRepository.getMoviesList(
            query: requestValue.query, page: requestValue.page, completion: { result in
            completion(result)
        })
    }
}

struct SearchOMDBMoviesUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}
