//
//  ListOfPopularVC.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization

class ListOfPopularVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var noDataView: NoDataView!
    var loadView: UILoadIndicatorView!
    var refreshControl: UIRefreshControl!

    private var dataSource = [ShortMovie]()
    var pageInfo: PageInfo? = nil
    var isLoading: Bool = false
    var filterSelectedItems: [Int]? = nil
    
    // MARK: - ListOfPopularVC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInterface()
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - FavoriteVC load data
    private func loadData() {
        self.loadMovies(page: 1)
    }
    
    private func loadMovies(page: Int) {
        if isLoading == false {
            isLoading = true
            self.tableView.tableHeaderView = nil
            loadView.beginAnimateion()
            self.tableView.tableFooterView = loadView
            
            APIManager.getLisOfPopular(page, filter: filterSelectedItems) { (responsePageInfo, object) in
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
                
                if (self.refreshControl.isRefreshing) {
                    let delay: DispatchTimeInterval = .milliseconds(500)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.refreshControl.endRefreshing()
                    })
                }
            }
        }
    }
    
    // MARK: - ListOfPopularVC interface setting
    private func setupInterface() {
        self.tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(self.pullToRefresh(sender:)),
                                 for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        noDataView = NoDataView.loadNoDataViewFromXib(frame: self.tableView.bounds)
        loadView = UILoadIndicatorView(frame: CGRect(x: 0.0,
                                                     y: 0.0,
                                                     width: self.tableView.frame.size.width,
                                                     height: 44.0))
    }
    
    // MARK: - ListOfPopularVC actions
    @objc func filterAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        vc.delegate = self
        if let selectedFilters = filterSelectedItems {
            vc.selectedGenres = selectedFilters
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func segmentControllAction(_ sender: Any) {
        
    }
    
    @objc private func pullToRefresh(sender: UIRefreshControl) {
        self.dataSource.removeAll()
        self.pageInfo = nil
        self.loadMovies(page: 1)
    }
}

// MARK: - UITableViewDelegate
extension ListOfPopularVC: UITableViewDelegate {
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
extension ListOfPopularVC: UITableViewDataSource {
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

// MARK: - SelectFilterDelegate
extension ListOfPopularVC: SelectFilterDelegate {
    func didSelectFilter(selectedFiltersIDs: [Int]?) {
        filterSelectedItems = selectedFiltersIDs
        self.dataSource.removeAll()
        self.tableView.reloadData()
        self.pageInfo = nil
        self.loadMovies(page: 1)
    }
}
