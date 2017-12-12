//
//  MovieDetailModel.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/11/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit

class MovieDetailModel: NSObject {
    var budget: Int? = nil
    var genres: [String]? = nil
    var production_companies: [String]? = nil
    var production_countries: [String]? = nil
    var release_date: String? = nil
    var revenue: Int? = nil
    var vote_average: Double? = nil
    var vote_count: Int? = nil
}
