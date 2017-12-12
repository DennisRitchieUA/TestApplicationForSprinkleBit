//
//  MovieDetailVC.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/11/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization
import Kingfisher

enum MovieDetailCellType: Int {
    case image = 0
    case textCell = 1
}

class MovieCellModel: NSObject {
    var title: String
    var stringValue: String
    var cellType: MovieDetailCellType
    
    init(title: String, stringValue: String, type: MovieDetailCellType) {
        self.title = title
        self.stringValue = stringValue
        self.cellType = type
        super.init()
    }
    
}
class MovieDetailVC: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var loadView: UILoadIndicatorView!
    
    var dataSource = [MovieCellModel]()
    var shortMode: ShortMovie! {
        didSet {
            self.title = shortMode.title
            if let backdrop_path = shortMode.backdrop_path {
                dataSource.append(MovieCellModel(title: "", stringValue: backdrop_path, type: .image))
            }
            if let overView = shortMode.overview, overView.count > 0 {
                dataSource.append(MovieCellModel(title: DPAutolocalizedString("movieDetailVC_overview", nil), stringValue: overView, type: .textCell))
            }
        }
    }
    
    // MARK: - MovieDetailVC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MovieDetailVC interface setting
    private func setupInterface() {
        
        let model = Favourites.mr_findFirst(with: NSPredicate(format: "movie_id == %@", shortMode.movie_id!))
        if (model == nil) {
            self.setupAddFavBtn()
        } else {
            self.setupRemoveFavBtn()
        }
        
        loadView = UILoadIndicatorView(frame: CGRect(x: 0.0,
                                                     y: 0.0,
                                                     width: self.tableView.frame.size.width,
                                                     height: 44.0))
    }
    
    private func setupAddFavBtn() {
        let addToFavBtn = UIBarButtonItem(image: UIImage(named: "addToFavourites"), style: .plain, target: self, action: #selector(self.addToFavourites(_:)))
        self.navigationItem.rightBarButtonItem = addToFavBtn
    }
    
    private func setupRemoveFavBtn() {
        let removeFromFavBtn = UIBarButtonItem(image: UIImage(named: "isFavourites"), style: .plain, target: self, action: #selector(self.removeFromFavourites(_:)))
        self.navigationItem.rightBarButtonItem = removeFromFavBtn
    }
    
    // MARK: - MovieDetailVC load data
    private func loadData() {
        loadView.beginAnimateion()
        self.tableView.tableFooterView = loadView
        APIManager.getDetailInfo(shortMode.movie_id?.intValue) { (object) in
            self.loadView.stopAnimateion()
            self.tableView.tableFooterView = nil
            
            if (object.error != nil) {
                self.showMessage(title: DPAutolocalizedString("warnint_message", nil), text: object.error?.localizedDescription ?? DPAutolocalizedString("Unknow_error", nil))
            } else {
                guard let model = object.response.first as? MovieDetailModel else { return }
                
                if let budget = model.budget, budget != 0 {
                    self.dataSource.append(MovieCellModel(title: DPAutolocalizedString("movieDetailVC_budget", nil), stringValue: "\(budget)", type: .textCell))
                }
                
                if let release_date = model.release_date {
                    self.dataSource.append(MovieCellModel(title: DPAutolocalizedString("movieDetailVC_release_date", nil), stringValue: release_date, type: .textCell))
                }
                
                if let revenue = model.revenue, revenue != 0 {
                    self.dataSource.append(MovieCellModel(title: DPAutolocalizedString("movieDetailVC_revenue", nil), stringValue: "\(revenue)", type: .textCell))
                }
                
                if let vote_average = model.vote_average, vote_average != 0.0 {
                    self.dataSource.append(MovieCellModel(title: DPAutolocalizedString("movieDetailVC_vote_average", nil), stringValue: "\(vote_average)", type: .textCell))
                }
                
                if let vote_count = model.vote_count, vote_count != 0 {
                    self.dataSource.append(MovieCellModel(title: DPAutolocalizedString("movieDetailVC_vote_count", nil), stringValue: "\(vote_count)", type: .textCell))
                }
                
                if let genres = model.genres, genres.count > 0 {
                    self.dataSource.append(MovieCellModel(title: DPAutolocalizedString("movieDetailVC_genres", nil), stringValue: genres.joined(separator: ", "), type: .textCell))
                }
                
                if let production_companies = model.production_companies, production_companies.count > 0 {
                    self.dataSource.append(MovieCellModel(title: DPAutolocalizedString("movieDetailVC_production_companies", nil), stringValue: production_companies.joined(separator: ", "), type: .textCell))
                }
                
                if let production_countries = model.production_countries, production_countries.count > 0 {
                    self.dataSource.append(MovieCellModel(title: DPAutolocalizedString("movieDetailVC_production_countries", nil), stringValue: production_countries.joined(separator: ", "), type: .textCell))
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - ListOfPopularVC actions
    @objc func addToFavourites(_ sender: Any) {
        let context = NSManagedObjectContext.mr_default()
        let favModel = Favourites.mr_findFirstOrCreate(byAttribute: "movie_id", withValue: shortMode.movie_id!, in: context)
        favModel.backdrop_path = shortMode.backdrop_path
        favModel.overview = shortMode.overview
        favModel.poster_path = shortMode.poster_path
        favModel.title = shortMode.title
        favModel.timeOfAddition = NSDate()
        favModel.vote_average = shortMode.vote_average
        favModel.release_year = shortMode.release_year
        context.mr_saveToPersistentStoreAndWait()
        self.setupRemoveFavBtn()
    }
    
    @objc func removeFromFavourites(_ sender: Any) {
        let context = NSManagedObjectContext.mr_default()
        let favModel = Favourites.mr_findFirstOrCreate(byAttribute: "movie_id", withValue: shortMode.movie_id!, in: context)
        favModel.mr_deleteEntity(in: context)
        context.mr_saveToPersistentStoreAndWait()
        self.setupAddFavBtn()
    }
}

// MARK: - UITableViewDataSource
extension MovieDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        switch model.cellType {
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BackdropCell", for: indexPath) as! BackdropCell
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/" + model.stringValue)
            cell.backdropImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "backdropPlaceholder"))
            return cell
        case .textCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDescriptionCell", for: indexPath) as! MovieDescriptionCell
            cell.titleTextLabel.text = model.title
            cell.descriptionTextLabel.text = model.stringValue
            return cell
        }
        
    }
}
