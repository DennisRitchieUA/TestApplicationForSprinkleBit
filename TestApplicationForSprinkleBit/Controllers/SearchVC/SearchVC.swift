//
//  SearchVC.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/12/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization

class SearchVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var noDataView: NoDataView!
    var loadView: UILoadIndicatorView!
    
    private var dataSource = [ShortMovie]()
    var pageInfo: PageInfo? = nil
    var isLoading: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInterface()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SearchVC interface setting
    private func setupInterface() {
        self.title = DPAutolocalizedString("SearchVC_title", nil)
        searchBar.placeholder = DPAutolocalizedString("SearchVC_search_bar_placeholder", nil)
        self.tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        
        noDataView = NoDataView.loadNoDataViewFromXib(frame: self.tableView.bounds)
        loadView = UILoadIndicatorView(frame: CGRect(x: 0.0,
                                                     y: 0.0,
                                                     width: self.tableView.frame.size.width,
                                                     height: 44.0))
    }
    
    // MARK: - SearchVC load data
    private func loadMovies(page: Int) {
        if isLoading == false {
            if let searchText = searchBar.text {
                isLoading = true
                self.tableView.tableHeaderView = nil
                loadView.beginAnimateion()
                self.tableView.tableFooterView = loadView
                APIManager.searchMovie(page, searchText: searchText) { (responsePageInfo, object) in
                    self.loadView.stopAnimateion()
                    self.tableView.tableFooterView = nil
                    
                    if (object.error != nil) {
                        self.showMessage(title: DPAutolocalizedString("warnint_message", nil), text: object.error?.localizedDescription ?? DPAutolocalizedString("Unknow_error", nil))
                    } else {
                        if (responsePageInfo != nil) {
                            self.pageInfo = responsePageInfo
                        }
                        
                        for model in object.response {
                            self.dataSource.append(model as! ShortMovie)
                        }
                    }
                    if (self.dataSource.count > 0) {
                        self.tableView.tableHeaderView = nil
                    } else {
                        self.tableView.tableHeaderView = self.noDataView
                    }
                    self.isLoading = false
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        vc.shortMode = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let metaObj = self.pageInfo {
            if self.isLoading == false && indexPath.row == self.dataSource.count - 5 {
                if metaObj.total_pages > metaObj.page {
                    self.loadMovies(page: metaObj.page + 1)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let model = dataSource[indexPath.row]
        cell.movieTitle.text = model.title
        cell.movieDescription.text = model.overview
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w780/" + (model.poster_path ?? ""))
        cell.movieImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "defaultImage"))
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.dataSource.removeAll()
        self.tableView.reloadData()
        self.loadMovies(page: 1)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count == 0) {
            self.dataSource.removeAll()
            self.tableView.reloadData()
        }
    }
}

