import Foundation

final class DefaultMoviesQueriesRepository {
    
    private let dataTransferService: DataTransferService
    private var moviesQueriesPersistentStorage: MoviesQueriesStorage
    
    init(
        dataTransferService: DataTransferService,
        moviesQueriesPersistentStorage: MoviesQueriesStorage
    ) {
        self.dataTransferService = dataTransferService
        self.moviesQueriesPersistentStorage = moviesQueriesPersistentStorage
    }
}

