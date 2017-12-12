//
//  FavoriteVC.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization

class FavoriteVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var noDataView: NoDataView!
    
    private let managerObjectContext = NSManagedObjectContext.mr_default()
    private var sortTypeDataSourceArray = [SortTypeModel]()
    private var dataSource = [Favourites]()
    private var selectedSort:SortTypeModel! {
        didSet {
            self.loadData()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - FavoriteVC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInterface()
        self.setupSortViewData()
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - FavoriteVC interface setting
    private func setupInterface() {
        self.tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        noDataView = NoDataView.loadNoDataViewFromXib(frame: self.tableView.bounds)
    }
    
    // MARK: - FavoriteVC load data
    private func loadData() {
        let sort = self.getSortType()
        self.dataSource = Favourites.mr_findAllSorted(by: sort.sortName, ascending: sort.ascending) as! [Favourites]
        self.tableView.reloadData()
        if (self.dataSource.count == 0) {
            self.tableView.tableHeaderView = noDataView
        } else {
            self.tableView.tableHeaderView = nil
        }
    }
    
    private func setupSortViewData() {
        let sortModel1 = SortTypeModel(type: .byAdding, name: DPAutolocalizedString("SortType_byAdding", nil))
        let sortModel2 = SortTypeModel(type: .byName, name: DPAutolocalizedString("SortType_byName", nil))
        let sortModel3 = SortTypeModel(type: .byYearPublishing, name: DPAutolocalizedString("SortType_byYearPublishing", nil))
        let sortModel4 = SortTypeModel(type: .byRating, name: DPAutolocalizedString("SortType_byRating", nil))
        sortTypeDataSourceArray = [sortModel1, sortModel2, sortModel3, sortModel4]
        selectedSort = sortModel1
    }
    
    // MARK: - FavoriteVC sort type
    func getSortType() -> (sortName: String, ascending: Bool) {
        switch selectedSort.sortType {
        case .byAdding:
            return ("timeOfAddition", false)
        case .byName:
            return ("title", true)
        case .byRating:
            return ("vote_average", false)
        case .byYearPublishing:
            return ("release_year", false)
        }
    }
    
    // MARK: - FavoriteVC actions
    @objc func sortedAction(_ sender: Any) {
        let index = sortTypeDataSourceArray.index(of: selectedSort) ?? 0
        let sortVC = UISortTypePickerView(scrollToRow: index)
        sortVC.delegate = self
        sortVC.dataSources = self
        self.present(sortVC, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension FavoriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        let context = NSManagedObjectContext.mr_default()
        var shortMovieModel = ShortMovie.mr_findFirst(byAttribute: "movie_id", withValue: model.movie_id!.intValue, in: context)
        if (shortMovieModel == nil) {
            shortMovieModel = ShortMovie.mr_createEntity(in: context)!
            shortMovieModel!.movie_id = model.movie_id
            shortMovieModel!.backdrop_path = model.backdrop_path
            shortMovieModel!.overview = model.overview
            shortMovieModel!.poster_path = model.poster_path
            shortMovieModel!.title = model.title
            shortMovieModel!.vote_average = model.vote_average
            shortMovieModel!.release_year = model.release_year
            context.mr_saveToPersistentStoreAndWait()
            vc.shortMode = shortMovieModel
        } else {
            vc.shortMode = shortMovieModel
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let alertController = UIAlertController(title: DPAutolocalizedString("warnint_message", nil), message: DPAutolocalizedString("FavoriteVC_remove_from_favourites", nil), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: DPAutolocalizedString("cancel_btn", nil), style: .cancel))
            alertController.addAction(UIAlertAction(title: DPAutolocalizedString("FavoriteVC_remove_from_favourites_yes", nil), style: .default, handler: { (action) in
                let context = NSManagedObjectContext.mr_default()
                let favModel = self.dataSource[indexPath.row]
                favModel.mr_deleteEntity(in: context)
                context.mr_saveToPersistentStoreAndWait()
                self.dataSource.remove(at: indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .left)
                self.tableView.endUpdates()
            }))
            self.present(alertController, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoriteVC: UITableViewDataSource {
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
        let model = self.dataSource[indexPath.row]
        cell.movieTitle.text = model.title
        cell.movieDescription.text = model.overview
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w780/" + (model.poster_path ?? ""))
        cell.movieImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "defaultImage"))
        return cell
    }
}

// MARK: - UISortTypePickerViewDataSource
extension FavoriteVC: UISortTypePickerViewDataSource {
    func pickerView(_ pickerView: UISortTypePickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortTypeDataSourceArray.count
    }
    
    func pickerView(_ pickerView: UISortTypePickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let model = sortTypeDataSourceArray[row]
        return model.name
    }
}

// MARK: - UISortTypePickerViewrDelegate
extension FavoriteVC: UISortTypePickerViewrDelegate {
    func pickerView(_ pickerView: UISortTypePickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedSort = sortTypeDataSourceArray[row]
    }
}
