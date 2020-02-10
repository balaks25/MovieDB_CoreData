//
//  GlobalIdentifier.swift
//  MovieDB
//
//  Created by Bala KS on 07/02/2020.
//  Copyright © 2020 bala. All rights reserved.
//

import Foundation
import UIKit

struct GlobalIdentifier {
    // Title
    static let AppTitle = "MovieDB"
    static let HostUrl = "https://omdbapi.com/"
    static let APIKey = "a0783fa9"
    
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    
    // REST Service
    static func getSearchMovie(search:String) -> String {
        let url = HostUrl+"?s=\(search)&apikey=\(APIKey)"
        return url
    }
    
    static func getMovieDetail(imdbID:String) -> String {
        let url = HostUrl+"?i=\(imdbID)&apikey=\(APIKey)"
        return url
    }
}
