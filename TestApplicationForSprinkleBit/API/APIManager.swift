//
//  APIManager.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DPLocalization
import ObjectMapper

class ResponseObject {
    var error:NSError? = nil
    var response = Array<Any>()
    var originalResponse:SwiftyJSON.JSON?
    let userData:AnyObject? = nil
}

class PageInfo: NSObject {
    var page: Int
    var total_results: Int
    var total_pages: Int
    
    init(page: Int, total_results: Int, total_pages: Int) {
        self.page = page
        self.total_results = total_results
        self.total_pages = total_pages
        super.init()
    }
    
}

typealias ResultHandler = (_ object: ResponseObject) -> Void

class APIManager: NSObject {
    fileprivate static let baseURL = "https://api.themoviedb.org/3"
    fileprivate static let apiKey = "fbe4e6280f6a460beaad8ebe2bc130ac"
    
    static var queue: DispatchQueue {
        let queue = DispatchQueue(label: "TestApplicationForSprinkleBit", attributes: [])
        return queue
    }
    
    class func getGenres(_ handler: (ResultHandler)? = nil) {
        queue.async {
            let url = "\(baseURL)/genre/movie/list"
            
            NetworkManager.requestWith(url,
                                       reqMethod: .get,
                                       dataToSend: nil,
                                       apiKey: apiKey,
                                       handler: { (object) in
                                        if object.originalResponse != nil && object.error == nil {
                                            guard let genreArray = object.originalResponse?["genres"].arrayObject as? [[AnyHashable: Any]] else {
                                                if handler != nil {
                                                    handler!(object)
                                                }
                                                return
                                            }
                                            let context = NSManagedObjectContext.mr_default()
                                            object.response = Genre.mr_import(from: genreArray, in: context)
                                            context.mr_saveToPersistentStoreAndWait()              
                                        } else {
                                            if (object.error == nil) {
                                                object.error = ErrorManager.createError(DPAutolocalizedString("Unknow_error", nil), code: object.error?.code ?? 000)
                                            }
                                        }
                                        if handler != nil {
                                            handler!(object)
                                        }
            })
        }
    }
    
    class func getLisOfPopular(_ page: Int!, filter: [Int]? = nil, handler: @escaping (PageInfo?, ResponseObject) -> Void) {
        queue.async {
            let url = "\(baseURL)/discover/movie"
            var params = [String : Any]()
            params["page"] = page
            if filter != nil {
                var stringFilter = ""
                for genre in filter! {
                    stringFilter = "\(genre), "
                }
                params["with_genres"] = stringFilter
            }
            
            NetworkManager.requestWith(url,
                                       reqMethod: .get,
                                       dataToSend: params,
                                       apiKey: apiKey,
                                       handler: { (object) in
                                        if object.originalResponse != nil && object.error == nil {
                                          let pageInfo = PageInfo(page: object.originalResponse!["page"].intValue, total_results: object.originalResponse!["total_results"].intValue, total_pages: object.originalResponse!["total_pages"].intValue)
                                            
                                            
                                            let df = DateFormatter()
                                            
                                            let context = NSManagedObjectContext.mr_default()
                                            
                                            if (page == 1) {
                                                ShortMovie.mr_truncateAll(in: context)
                                            }
                                            
                                            for json in object.originalResponse!["results"].arrayValue {
                                                df.dateFormat = "yyyy-MM-dd"
                                                let movieID = json["id"].numberValue
                                                let model = ShortMovie.mr_findFirstOrCreate(byAttribute: "movie_id", withValue: movieID, in: context)
                                                model.title = json["title"].string
                                                model.poster_path = json["poster_path"].string
                                                model.overview = json["overview"].string
                                                model.backdrop_path = json["backdrop_path"].string
                                                model.vote_average = json["vote_average"].number
                                                if let stringDate = json["release_date"].string {
                                                    if let releaseDate = df.date(from: stringDate) {
                                                        df.dateFormat = "yyyy"
                                                        model.release_year = df.string(from: releaseDate)
                                                    }
                                                }
                                                object.response.append(model)
                                            }
                                            context.mr_saveToPersistentStoreAndWait()
                                            handler(pageInfo, object)
                                        } else {
                                            if (object.error == nil) {
                                                object.error = ErrorManager.createError(DPAutolocalizedString("Unknow_error", nil), code: object.error?.code ?? 000)
                                            }
                                            handler(nil, object)
                                        }
            })
        }
    }
    
    class func searchMovie(_ page: Int!, searchText: String, handler: @escaping (PageInfo?, ResponseObject) -> Void) {
        queue.async {
            let url = "\(baseURL)/search/movie"
            var params = [String : Any]()
            params["page"] = page
            params["query"] = searchText
            
            NetworkManager.requestWith(url,
                                       reqMethod: .get,
                                       dataToSend: params,
                                       apiKey: apiKey,
                                       handler: { (object) in
                                        if object.originalResponse != nil && object.error == nil {
                                            let pageInfo = PageInfo(page: object.originalResponse!["page"].intValue, total_results: object.originalResponse!["total_results"].intValue, total_pages: object.originalResponse!["total_pages"].intValue)
                                            
                                            
                                            let df = DateFormatter()
                                            
                                            let context = NSManagedObjectContext.mr_default()
                                            
                                            if (page == 1) {
                                                ShortMovie.mr_truncateAll(in: context)
                                            }
                                            
                                            for json in object.originalResponse!["results"].arrayValue {
                                                df.dateFormat = "yyyy-MM-dd"
                                                let movieID = json["id"].numberValue
                                                let model = ShortMovie.mr_findFirstOrCreate(byAttribute: "movie_id", withValue: movieID, in: context)
                                                model.title = json["title"].string
                                                model.poster_path = json["poster_path"].string
                                                model.overview = json["overview"].string
                                                model.backdrop_path = json["backdrop_path"].string
                                                model.vote_average = json["vote_average"].number
                                                if let stringDate = json["release_date"].string {
                                                    if let releaseDate = df.date(from: stringDate) {
                                                        df.dateFormat = "yyyy"
                                                        model.release_year = df.string(from: releaseDate)
                                                    }
                                                }
                                                object.response.append(model)
                                            }
                                            context.mr_saveToPersistentStoreAndWait()
                                            handler(pageInfo, object)
                                        } else {
                                            if (object.error == nil) {
                                                object.error = ErrorManager.createError(DPAutolocalizedString("Unknow_error", nil), code: object.error?.code ?? 000)
                                            }
                                            handler(nil, object)
                                        }
            })
        }
    }
    
    class func getDetailInfo(_ movieID: Int!, handler: @escaping (ResponseObject) -> Void) {
        queue.async {
            let url = "\(baseURL)/movie/\(movieID!)"
            
            NetworkManager.requestWith(url,
                                       reqMethod: .get,
                                       dataToSend: nil,
                                       apiKey: apiKey,
                                       handler: { (object) in
                                        if object.originalResponse != nil && object.error == nil {
                                            let movieDetailModel = MovieDetailModel()
                                            movieDetailModel.budget = object.originalResponse!["budget"].int
                                            
                                            var genres = [String]()
                                            for model in object.originalResponse!["genres"].arrayValue {
                                                genres.append(model["name"].stringValue)
                                            }
                                            movieDetailModel.genres = genres
                                            
                                            var production_companies = [String]()
                                            for model in object.originalResponse!["production_companies"].arrayValue {
                                                production_companies.append(model["name"].stringValue)
                                            }
                                            movieDetailModel.production_companies = production_companies
                                            
                                            var production_countries = [String]()
                                            for model in object.originalResponse!["production_countries"].arrayValue {
                                                production_countries.append(model["name"].stringValue)
                                            }
                                            movieDetailModel.production_countries = production_countries
                                            
                                            movieDetailModel.release_date = object.originalResponse!["release_date"].string
                                            movieDetailModel.revenue = object.originalResponse!["revenue"].int
                                            movieDetailModel.vote_average = object.originalResponse!["vote_average"].double
                                            movieDetailModel.vote_count = object.originalResponse!["vote_count"].int
                                            object.response = [movieDetailModel]
                                            handler(object)
                                        } else {
                                            if (object.error == nil) {
                                                object.error = ErrorManager.createError(DPAutolocalizedString("Unknow_error", nil), code: object.error?.code ?? 000)
                                            }
                                            handler(object)
                                        }
            })
        }
    }
}

private class NetworkManager {
    class func requestWith(_ url: String,
                           reqMethod: HTTPMethod,
                           dataToSend: [String : Any]?,
                           apiKey: String?,
                           handler: @escaping (ResponseObject) -> Void) {
        
        let object = ResponseObject()
        var params = dataToSend ?? [String: Any]()
        
        if let key = apiKey {
            params["api_key"] = key
        }
        
        let lang = DPLocalizationManager.current().currentLanguage
        params["language"] = lang
        
        myPrint("parameters:\n \(String(describing: params))")
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        Alamofire.request(url, method: reqMethod,
                          parameters: params,
                          encoding: URLEncoding(),
                          headers: nil).responseJSON { response in
                            DispatchQueue.main.async {
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            }
                            myPrint(response.request)
                            myPrint(response.request?.httpMethod)
                            myPrint(response.response)
                            myPrint(response.result)
                            myPrint(response.result.value)
                            myPrint(response.error)
                            
                            switch response.result {
                            case .success(let JSON):
                                let jsonS = SwiftyJSON.JSON(JSON)
                                object.originalResponse = jsonS
                                if let jsonSuccess = jsonS["success"].bool {
                                    if (!jsonSuccess) {
                                        object.error = ErrorManager.createError(jsonS["status_message"].stringValue, code: jsonS["status_code"].intValue)
                                    }
                                }
                                
                                
                                handler(object)
                            case .failure(let error):
                                object.error = error as NSError
                                handler(object)
                            }
        }
    }
}
