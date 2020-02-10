//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Bala KS on 07/02/20.
//  Copyright © 2020 bala. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var runtimeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var genreStackView: UIStackView!
    
    var imdbId = ""
    var movieDetail: MovieDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.save(movieDetail: movieDetail!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        self.movieNameLabel.text = (movieDetail?.title)!
        self.nameLabel.text = (movieDetail?.production)!
        self.plotLabel.text = (movieDetail?.plot)!
        self.directorLabel.text = "Director : "+(movieDetail?.director)!
        self.writerLabel.text = "Writer : "+(movieDetail?.writer)!
        self.actorsLabel.text = "Actors : "+(movieDetail?.actors)!
        self.ratingButton.setTitle((movieDetail?.imdbrating)!, for: .normal)
        self.runtimeButton.setTitle((movieDetail?.runtime)!, for: .normal)
        
        let array = (movieDetail?.genre)!.components(separatedBy: ", ")
        for genreString in array {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 12.0)
            label.text = genreString
            label.frame = CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width + 10, height: genreStackView.frame.size.height)
            label.textColor = .white
            label.backgroundColor = .lightGray
            label.textAlignment = .center
            label.layer.cornerRadius = 15
            genreStackView.addArrangedSubview(label)
        }
        
        self.moviePosterImage.downloaded(from: (movieDetail?.poster)!)
    }
    
    func save(movieDetail: MovieDetail) { // Save the searched movies to Core data before listing to collection view
        // 1
        let managedContext = DatabaseController.getContext()
        
        // 2
        let movieDetailInfoEntity = NSEntityDescription.entity(forEntityName: "MovieDetail", in: managedContext)!
        let ratingsInfoEntity = NSEntityDescription.entity(forEntityName: "Ratings", in: managedContext)!
        
        let movieDetailInfo = NSManagedObject(entity: movieDetailInfoEntity, insertInto: managedContext)
        // 3
        movieDetailInfo.setValue(movieDetail.title, forKeyPath: "title")
        movieDetailInfo.setValue(movieDetail.year, forKeyPath: "year")
        movieDetailInfo.setValue(movieDetail.rated, forKeyPath: "rated")
        movieDetailInfo.setValue(movieDetail.released, forKeyPath: "released")
        movieDetailInfo.setValue(movieDetail.runtime, forKeyPath: "runtime")
        movieDetailInfo.setValue(movieDetail.genre, forKeyPath: "genre")
        movieDetailInfo.setValue(movieDetail.director, forKeyPath: "director")
        movieDetailInfo.setValue(movieDetail.writer, forKeyPath: "writer")
        movieDetailInfo.setValue(movieDetail.actors, forKeyPath: "actors")
        movieDetailInfo.setValue(movieDetail.plot, forKeyPath: "plot")
        movieDetailInfo.setValue(movieDetail.response, forKeyPath: "response")
        movieDetailInfo.setValue(movieDetail.language, forKeyPath: "language")
        movieDetailInfo.setValue(movieDetail.country, forKeyPath: "country")
        movieDetailInfo.setValue(movieDetail.awards, forKeyPath: "awards")
        movieDetailInfo.setValue(movieDetail.poster, forKeyPath: "poster")
        movieDetailInfo.setValue(movieDetail.metascore, forKeyPath: "metascore")
        movieDetailInfo.setValue(movieDetail.imdbrating, forKeyPath: "imdbrating")
        movieDetailInfo.setValue(movieDetail.imdbvotes, forKeyPath: "imdbvotes")
        movieDetailInfo.setValue(movieDetail.imdbid, forKeyPath: "imdbid")
        movieDetailInfo.setValue(movieDetail.type, forKeyPath: "type")
        movieDetailInfo.setValue(movieDetail.dvd, forKeyPath: "dvd")
        movieDetailInfo.setValue(movieDetail.boxoffice, forKeyPath: "boxoffice")
        movieDetailInfo.setValue(movieDetail.production, forKeyPath: "production")
        movieDetailInfo.setValue(movieDetail.website, forKeyPath: "website")
        movieDetailInfo.setValue(movieDetail.response, forKeyPath: "response")
        
        for rating in movieDetail.ratings {
            let ratingsInfo = NSManagedObject(entity: ratingsInfoEntity, insertInto: managedContext)
            ratingsInfo.setValue(rating.source, forKey: "source")
            ratingsInfo.setValue(rating.value, forKey: "value")
            movieDetailInfo.setValue(ratingsInfo, forKeyPath: "ratingsInfo")
        }
        DatabaseController.saveContext()
    }
    
    func deleteAllRecords(entityName : String) {
        // deleting entity records from Core Data
        let managedContext = DatabaseController.getContext()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try managedContext.execute(request)
            try managedContext.save()
            print("Movie Details Deleted Successfully")
        } catch {
            print ("There was an error")
        }
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        // Back
        self.deleteAllRecords(entityName: "MovieDetail")
        self.deleteAllRecords(entityName: "Ratings")
        self.navigationController?.popViewController(animated: true)
    }
}
