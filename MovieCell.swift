//
//  MovieCell.swift
//  IMDb
//
//  Created by STUDENT on 2021-12-11.
//

import UIKit

//Movie Cell Class that declares a subclass of the UICollectionViewCell object

class MovieCell: UICollectionViewCell{
    //Image view outlet property that represents the imageview in the CollectionView Cell
    @IBOutlet var movieImage: UIImageView!
    
    //This is the update function that updates the Movie cell with the movie reel image
    func update(displaying image: UIImage?){
        //Image to Display object
        if let imageToDisplay = UIImage(named:"movie_reel.png"){
            //Setting the movie Images image to the movie reel
            movieImage.image = imageToDisplay
            
        }else{
            //Setting the movie image to nil
            movieImage.image = nil
        }
    }
}
