//
//  DetailViewController.swift
//  IMDb
//
//  Created by STUDENT on 2021-12-11.
//

import UIKit

//This is the DetailView Controller that subclasses the UIView Controller
class DetailViewController: UIViewController{
    
   //TextField for title
    @IBOutlet var titleTextField: UITextField!
    //Year Label variable for the Year
    @IBOutlet var yearLabel: UILabel!
    //ID Label for imdbID
    @IBOutlet var idLabel: UILabel!
    //Plot textfield for the plot of the movie
    @IBOutlet var plotTextField: UITextField!
    
    
    
    //Movie variable
    var movie: Movie!
    //Poster variable that contains URL
    var poster: String = ""
    
    //This button searches through the OMDB API for the Movie that the user inputs
    @IBAction func searchPressed(_ sender: UIButton) {
        if let input = titleTextField.text
        {
            //This variable changes the spaces in the user's search to plus symbols to adhere to the API's requirements
            let updatedInput = input.replacingOccurrences(of: " ", with: "+")
            //Constructed URL
            let url = URL(string: " https://www.omdbapi.com/?t=\(updatedInput)&plot=full&apikey=mohawk")
            //Task object that creates a URLSession and returns JSON
            let task = URLSession.shared.dataTask(with: url!) {
                (data, response, error) in
                //Constructing JSON string
                if let jsonData = data {
                    OperationQueue.main.addOperation {
                        if let jsonString = String(data: jsonData, encoding: .utf8){
                            print(jsonString)
                    }
                    do{
                        //Parsing the JSON in Movie instance and setting UI Elements and the Poster property
                        let decoder = JSONDecoder()
                        let movie = try decoder.decode(Movie.self, from:jsonData)
                        self.titleTextField.text = "\(movie.Title)"
                        self.yearLabel.text = movie.Year
                        self.idLabel.text = movie.imdbID
                        self.plotTextField.text = movie.Plot
                        self.poster = movie.Poster
                    }catch {
                        //If the movie isn't found, parsing fails, and all UI Elements except Year Label are made blank. Not found to show the movie cannot be found in the OMDB API
                        self.titleTextField.text = ""
                        self.yearLabel.text = "Not found"
                        self.idLabel.text = ""
                        self.plotTextField.text = ""
                    }
                    }
                    //Error messages when parsing fails
                } else if let requestError = error{
                    print("Error fetching movie \(requestError)")
                } else {
                    print("Unexpected error with the request")
                }
            }
            task.resume()
        }
    }
    
    //View will appear which sets defaults for the Navigation item or sets the UI fields using the movie object
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       //If there is no Movie, nav item is set to New Movie
        if movie.Title == "<Placeholder>"{
            navigationItem.title = "New Movie"
        }else{
            //If there is a movie, all UI elements are set for user to view, as well as Poster URL
            navigationItem.title = movie.Title
            titleTextField.text = movie.Title
            yearLabel.text = movie.Year
            idLabel.text = movie.imdbID
            plotTextField.text = movie.Plot
            poster = movie.Poster
        }
    }
    //View will Disappear object that sets UI Elements if a movie cannot be found
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Setting each UI Object if a Movie cannot be found
        if yearLabel.text != "" && yearLabel.text != "Not found"{
            if let value = idLabel.text{
                movie.imdbID = value
            }
            //Setting the movie's elements to the UI Elements
            movie.Title = titleTextField.text!
            movie.Year = yearLabel.text!
            movie.Plot = plotTextField.text!
            movie.Poster = poster
            
        }
    }
    
    
}
