// **Note**: DTOs structs are mapped into Domains here, and Repository protocols does not contain DTOs

import Foundation

final class DefaultMoviesRepository {

    private let dataTransferService: DataTransferService
    private let cache: MoviesResponseStorage

    init(
        dataTransferService: DataTransferService,
        cache: MoviesResponseStorage
    ) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension DefaultMoviesRepository: MoviesRepository {
    func getMoviesList(
        query: MovieQuery,
        page: Int,
        completion: @escaping (Result<OMDBMoviesPage, Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()
        
        let requestDTO = OMDBMoviesRequestDTO(query: query.query, page: page)
        guard !task.isCancelled else { return task}

        let endpoint = APIEndpoints.getOBDMMovies(with: requestDTO)
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
