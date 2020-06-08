//
//  MovieDT.swift
//  MovieShare
//
//  Created by Ramon Amini on 5/27/20.
//  Copyright © 2020 Ramon Amini. All rights reserved.
//

import Foundation

class MovieDT{
    var title:String = ""
    var description:String = ""
    var releaseDate:String = ""
    var stars:Double
    
    init(){
        title = ""
        description = ""
        releaseDate = ""
        stars = 0
    }
    
    init(title: String, description: String, releaseDate: String, stars: Double) {
        self.title = title
        self.description = description
        self.releaseDate = releaseDate
        self.stars = stars
    }
    
}
