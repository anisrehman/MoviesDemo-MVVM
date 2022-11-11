//
//  MoviesViewController.swift
//  MoviesDemo
//
//  Created Anis Rehman on 11/02/2020.
//  Copyright © 2020 Anis ur Rehman. All rights reserved.
//
//

import UIKit
import Combine

class MoviesViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var progressView: UIView!

    var viewModel: MoviesViewModel!
    var router: MoviesRouter!
    private var subscribers: [AnyCancellable] = []

    var movies: [Movie] = []
	override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchMovies(category: .popular)
    }
}


// MARK: - Actions
extension MoviesViewController {
    @IBAction func categoryAction(_ sender: UISegmentedControl) {
        self.fetchMovies(category: self.selectedCategory)
    }
}
// MARK: - Private Methods/Properties
extension MoviesViewController {
    private var selectedCategory: Category {
        get {
            return Category(rawValue: segmentedControl.selectedSegmentIndex) ?? .popular
        }
    }
    
    private func setup() {
        viewModel.$movies.sink { [weak self] movies in
            DispatchQueue.main.async {
                self?.movies = movies
                self?.updateView()
            }
        }.store(in: &subscribers)
    }

    private func fetchMovies(category: Category) {
        clearSearch()
        showProgress()
        viewModel.fetchMovies(category)
    }

    private func showProgress() {
        self.view.isUserInteractionEnabled = false
        self.progressView.isHidden = false
    }

    private func hideProgress() {
        self.view.isUserInteractionEnabled = true
        self.progressView.isHidden = true
    }

    private func updateView() {
        hideProgress()
        tableView.reloadData()
    }

    private func clearSearch() {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.movies = []
        self.tableView.reloadData();
    }
}
// MARK: - TableView DataSource
extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.movieTableViewCell.rawValue) as! MovieTableViewCell
        cell.displayContents(of: self.movies[indexPath.row])
        return cell
    }
}
// MARK: - TableView Delegate
extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.router.routeToMovieDetails(movie: self.movies[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - SearchBar Delegate
extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            viewModel.clearSearch(category: self.selectedCategory)
        } else {
            viewModel.searchMovies(text: searchText, category: self.selectedCategory)
        }
    }
}
