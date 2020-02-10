//
//  Movie.swift
//  MovieDB
//
//  Created by Bala KS on 07/02/20.
//  Copyright © 2020 bala. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct Movie: Codable {
    var search: [Search]?
    var totalresults: String?
    var response: String?
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalresults = "totalResults"
        case response = "Response"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        search = try values.decode([Search].self, forKey: .search)
        totalresults = try values.decode(String.self, forKey: .totalresults)
        response = try values.decode(String.self, forKey: .response)
    }
}

struct Search: Codable {
    var title: String?
    var year: String?
    var imdbid: String?
    var type: String?
    var poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbid = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        year = try values.decode(String.self, forKey: .year)
        imdbid = try values.decode(String.self, forKey: .imdbid)
        type = try values.decode(String.self, forKey: .type)
        poster = try values.decode(String.self, forKey: .poster)
    }
}
