//  I, Olaoluwa Anthony-Egorp, student number 000776467, certify that this material is my original work.
//No other person's work has been used without due acknowledgement and I have not made my work available to anyone else.
//  MoviesViewController.swift
//  IMDb
//
//  Created by STUDENT on 2021-12-11.
//

import UIKit

//This is the Movies View Controller that subclasses the CollectionView Controller
class MoviesViewController: UICollectionViewController{
    
    //Array of movies
    var movies = [Movie]()
    //Global ImageStore object
    var store = ImageStore()
    //number of Items in Section that returns the number of objects in the array
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    //Updating the cell for each movie Item, this sets a cell's to the movie reel picture if there's no title or Poster URL, it also retrieves a reusable Movie Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> MovieCell {
        //Image Store object
        
        //Identifier Movie Cell object
        let identifier = "MovieCell"
        //Setting a cell variable to an instance of a MovieCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MovieCell
        
        //This object gets the current movie in the array
        let movie = movies[indexPath.row]
        cell.movieImage?.image = movie.imdbID == nil ? UIImage(named: "movie_reel.png") : cell.movieImage.image
        //Setting the cell's image to the default movie reel by Checking to see if the current movie has a default title or no Poster URL
        if movie.Title == "<Placeholder>" || movie.Poster == "N/A"{
            cell.movieImage.image = UIImage(named: "movie_reel.png")
        }
        else if movie.Poster != nil && movie.Poster != "N/A"
        {
            //Setting the cells image to the movie's poster image if one exists
            if let image = store.image(forKey: movie.Poster){
            cell.movieImage.image = image
            }
            //This logic creates a URLSession data task with the URL, retrieves the data, and converts it to an image. Afterwards, the image is stored in the Imagestore object
            else
            {
                //Url Object that contains movie poster's URL
                let url = URL(string:movie.Poster)
                //Task object that encodes url into JSON
                let task = URLSession.shared.dataTask(with: url!) {
                    (data, response, error) in
                    if let jsonData = data {
                        OperationQueue.main.addOperation {
                            if let jsonString = String(data: jsonData, encoding: .utf8){
                                print(jsonString)
                        }
                        }
                        do{
                            //This part decodes the JSON, attempting to get an image for the poster URL if there is no initial image
                            let decoder = JSONDecoder()
                            let movieImage = try decoder.decode(Movie.self, from:jsonData)
                            let finalImage = self.store.image(forKey: movieImage.Poster)
                            self.store.setImage(finalImage!, forKey: movie.Poster)
                        }catch {
                            movie.Poster = "N/A"
                        }
                    } else if let requestError = error{
                        print("Error fetching movie \(requestError)")
                    } else {
                        print("Unexpected error with the request")
                    }
                }
                task.resume()
            }
            
        }
        
        //Updating cell
        cell.update(displaying: nil)
       
        //RETURN MOVIE REEL IMAGE
        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let store = ImageStore()
//
//        let cell = movies[indexPath.row]
//        let cellKey = movies[indexPath.row].imdbID
//
//        if let image = store.image(forKey: cellKey){
//            OperationQueue.main.addOperation {
//                completion(success(image))
//            }
//        }
//        //Download the image data
//
//    }
    
    //New Movie function that goes to the DetailViewController when the add button on the inital page is clicked
    @IBAction func newMovie(_ sender: UIBarButtonItem) {
        //Create new movie
        let movie = Movie()
          
        //Add new movie to array
        movies.append(movie)
        //Calling insertItems on collection view to add new cell
        let indexPath = IndexPath(row: movies.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])

    }
    
    //This is the ViewWillAppear function that refreshes the data in the colelction view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Reloading collection view data
        collectionView.reloadData()
    }
    
    //This is the prepare function that connects the Segue to the DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        //This is the name of the segue, this sets the destination of the segue as a DetailViewController
        case "showMovie":
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let movie = movies[selectedIndexPath.row]
                let destinationVC = segue.destination as! DetailViewController
                destinationVC.movie = movie
                
            }
        default: preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    //This is the viewDidLoad function that reloads the collection views' sections
    override func viewDidLoad() {
        super.viewDidLoad()
        //Reload's sections for collection View
        self.collectionView.reloadSections(IndexSet(integer: 0))
    }
}
