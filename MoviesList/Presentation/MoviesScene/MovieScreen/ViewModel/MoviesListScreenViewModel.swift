//
//  MoviesListScreenViewModel.swift
//  MoviesList
//
//  Created by Nguyen The Trinh on 3/18/23.
//

import Foundation

struct MoviesListViewModelActions {
}

enum MoviesListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol MoviesListScreenViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
}

protocol MoviesListScreenViewModelOutput {
    var items: Observable<[MovieItemViewModel]> { get }
    var loading: Observable<MoviesListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

typealias MoviesListScreenViewModel = MoviesListScreenViewModelInput & MoviesListScreenViewModelOutput


final class DefaultMoviesListScreenViewModel: MoviesListScreenViewModel {
    private let searchMoviesUseCase: SearchMoviesUseCase
    private let actions: MoviesListViewModelActions?

    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    private var pages: [OMDBMoviesPage] = []
    private var moviesLoadTask: Cancellable? { willSet { moviesLoadTask?.cancel() } }
    private let onMainThreadExecutor: OnMainThreadExecutor = DefaultOnMainThreadExecutor()

    // MARK: - OUTPUT

    let items: Observable<[MovieItemViewModel]> = Observable([])
    let loading: Observable<MoviesListViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Movies", comment: "")
    
    init(
        searchMoviesUseCase: SearchMoviesUseCase,
        actions: MoviesListViewModelActions? = nil
    ) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.actions = actions
    }
    
    private func appendPage(_ moviesPage: OMDBMoviesPage) {
        currentPage += 1
        totalPageCount = Int(Double(moviesPage.totalResult / 10).rounded(.up))

        pages = pages
            + [moviesPage]

        items.value = pages.movies.map(MovieItemViewModel.init)
    }
    
    private func load(movieQuery: MovieQuery, loading: MoviesListViewModelLoading) {
        self.loading.value = loading
        query.value = movieQuery.query
        
        searchMoviesUseCase.getMovies(requestValue: .init(query: movieQuery, page: nextPage)) { [weak self] result in
            self?.onMainThreadExecutor.execute {
                switch result {
                case .success(let page):
                    self?.appendPage(page)
                case .failure(let error):
                    self?.handle(error: error)
                }
                self?.loading.value = .none
            }
        }
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading movies", comment: "")
    }
}

extension DefaultMoviesListScreenViewModel {

    func viewDidLoad() {}

    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        load(movieQuery: .init(query: query.value),
             loading: .nextPage)
    }

    func didSearch(query: String) {
        self.query.value = query
        load(movieQuery: .init(query: query), loading: .nextPage)
    }
}
