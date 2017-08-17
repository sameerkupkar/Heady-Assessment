//
//  File.swift
//  MovieSearch
//
//  Created by Apple on 16/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
class Model: NSObject {
    var title: String?
    var overview: String?
    var posterPath: String?
    var daterelease:String?
    var vote :Int?
    let baseUrl: String = "https://image.tmdb.org/t/p/w500"
    
    init(json: NSDictionary){
        if let title = json["title"] as? String{
            self.title = title
        }
        if let overview = json["overview"] as? String{
            self.overview = overview
        }
        if let posterPath = json["poster_path"] as? String {
            self.posterPath = posterPath
        }
        
        if let daterelease = json["release_date"] as? String{
        
        self.daterelease = daterelease
        
        }
        if let vote = json["vote_average"] as? Int{
        self.vote = vote
        }
        
    }
}
