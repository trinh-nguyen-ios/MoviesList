import UIKit
import SwiftUI

final class MoviesSceneDIContainer: MoviesSearchFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies

    // MARK: - Persistent Storage
    lazy var moviesQueriesStorage: MoviesQueriesStorage = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    lazy var moviesResponseCache: MoviesResponseStorage = CoreDataMoviesResponseStorage()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies        
    }
    
    // MARK: - Use Cases
    func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
        DefaultSearchMoviesUseCase(
            moviesRepository: makeMoviesRepository()
        )
    }
    
    // MARK: - Repositories
    func makeMoviesRepository() -> MoviesRepository {
        DefaultMoviesRepository(
            dataTransferService: dependencies.apiDataTransferService,
            cache: moviesResponseCache
        )
    }
    
    // MARK: - Movies List
    
    func makeMoviesListScreenViewController(actions: MoviesListViewModelActions) -> MoviesListSceenViewController {
        MoviesListSceenViewController.create(
            with: makeMoviesListScreenViewModel(actions: actions)
        )
    }
    
    func makeMoviesListScreenViewModel(actions: MoviesListViewModelActions) -> MoviesListScreenViewModel {
        DefaultMoviesListScreenViewModel(
            searchMoviesUseCase: makeSearchMoviesUseCase(),
            actions: actions
        )
    }

    // MARK: - Flow Coordinators
    func makeMoviesSearchFlowCoordinator(navigationController: UINavigationController) -> MoviesSearchFlowCoordinator {
        MoviesSearchFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
