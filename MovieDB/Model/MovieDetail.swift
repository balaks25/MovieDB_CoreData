//
//  MovieDetail.swift
//  MovieDB
//
//  Created by Bala KS on 07/02/20.
//  Copyright © 2020 bala. All rights reserved.
//

import Foundation

struct MovieDetail : Codable {
    var title: String?
    var year: String?
    var rated: String?
    var released: String?
    var runtime: String?
    var genre: String?
    var director: String?
    var writer: String?
    var actors: String?
    var plot: String?
    var language: String?
    var country: String?
    var awards: String?
    var poster: String?
    var ratings: [Ratings]
    var metascore: String?
    var imdbrating: String?
    var imdbvotes: String?
    var imdbid: String?
    var type: String?
    var dvd: String?
    var boxoffice: String?
    var production: String?
    var website: String?
    var response: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
    
        case metascore = "Metascore"
        case imdbrating = "imdbRating"
        case imdbvotes = "imdbVotes"
        case imdbid = "imdbID"
        case type = "Type"
        
        case dvd = "DVD"
        case boxoffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        year = try values.decode(String.self, forKey: .year)
        rated = try values.decode(String.self, forKey: .rated)
        released = try values.decode(String.self, forKey: .released)
        runtime = try values.decode(String.self, forKey: .runtime)
        genre = try values.decode(String.self, forKey: .genre)
        director = try values.decode(String.self, forKey: .director)
        writer = try values.decode(String.self, forKey: .writer)
        actors = try values.decode(String.self, forKey: .actors)
        plot = try values.decode(String.self, forKey: .plot)
        language = try values.decode(String.self, forKey: .language)
        country = try values.decode(String.self, forKey: .country)
        awards = try values.decode(String.self, forKey: .awards)
        poster = try values.decode(String.self, forKey: .poster)
        ratings = try values.decode([Ratings].self, forKey: .ratings)
        metascore = try values.decode(String.self, forKey: .metascore)
        imdbrating = try values.decode(String.self, forKey: .imdbrating)
        imdbvotes = try values.decode(String.self, forKey: .imdbvotes)
        imdbid = try values.decode(String.self, forKey: .imdbid)
        type = try values.decode(String.self, forKey: .type)
        dvd = try values.decode(String.self, forKey: .dvd)
        boxoffice = try values.decode(String.self, forKey: .boxoffice)
        production = try values.decode(String.self, forKey: .production)
        website = try values.decode(String.self, forKey: .website)
        response = try values.decode(String.self, forKey: .response)
    }
}

struct Ratings : Codable {
    var source: String?
    var value: String?
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        source = try values.decode(String.self, forKey: .source)
        value = try values.decode(String.self, forKey: .value)
    }
}
