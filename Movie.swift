//
//  Movie.swift
//  IMDb
//
//  Created by STUDENT on 2021-12-11.
//

import UIKit

//This is the Movie class. It contains the title, year, plot, poster, and ID fields
class Movie : Codable{
    
    //Title variable
    var Title: String
    //Year variable
    var Year: String
    //Plot variable
    var Plot: String
    //Poster variable
    var Poster: String
    //ID variable
    var imdbID: String
    
    //Initializer variable: setting default values for each field variable
    init(){
        self.Title = "<Placeholder>"
        self.Year = ""
        self.Plot = ""
        self.Poster = ""
        self.imdbID = ""
    }
}
