import UIKit

protocol MoviesSearchFlowCoordinatorDependencies  {
    func makeMoviesListScreenViewController(
        actions: MoviesListViewModelActions
    ) -> MoviesListSceenViewController
}

final class MoviesSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MoviesSearchFlowCoordinatorDependencies
    private weak var moviesListScreenVC: MoviesListSceenViewController?
    
    init(navigationController: UINavigationController,
         dependencies: MoviesSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = MoviesListViewModelActions()
        let vc = dependencies.makeMoviesListScreenViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        moviesListScreenVC = vc
    }
}
