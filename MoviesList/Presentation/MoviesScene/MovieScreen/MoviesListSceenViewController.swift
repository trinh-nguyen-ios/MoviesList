//
//  MoviesListSceenViewController.swift
//  MoviesList
//
//  Created by Nguyen The Trinh on 3/18/23.
//

import UIKit

class MoviesListSceenViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var viewModel: MoviesListScreenViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 0, left: 12, bottom: 16, right: 12)
        collectionView.register(UINib(nibName: "MovieItemCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MovieItemCell")
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func bind(to viewModel: MoviesListScreenViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    private func updateItems() {
        collectionView?.reloadData()
    }

    private func updateLoading(_ loading: MoviesListViewModelLoading?) {
        // Show loading indicator
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
    
    static func create(
        with viewModel: MoviesListScreenViewModel
    ) -> MoviesListSceenViewController {
        let view = MoviesListSceenViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
}

extension MoviesListSceenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieItemCell", for: indexPath) as! MovieItemCell
        cell.set(viewModel.items.value[indexPath.row])
        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let cellPadding: CGFloat = 4
        let width: CGFloat = ((UIScreen.main.bounds.width - padding*2) - cellPadding) / 2
        let height: CGFloat = width*1.5
        
        return CGSize(width: width, height: height)
    }
}

extension MoviesListSceenViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel.didSearch(query: searchText)
    }
}
