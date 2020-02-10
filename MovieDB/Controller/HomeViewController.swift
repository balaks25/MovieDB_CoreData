//
//  ViewController.swift
//  MovieDB
//
//  Created by Bala KS on 07/02/20.
//  Copyright © 2020 bala. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var collectionView : UICollectionView!
    var searchMovies: Movie?
    var movieDetail: MovieDetail?
    var searchResult: [[String:String]]? = []
    var isSearch : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // deleting old data from DB
        self.deleteAllRecords(entityName: "Movie")
        self.deleteAllRecords(entityName: "Search")
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    fileprivate func getMovies(_ searchString: String) {
        let session = URLSession.shared
        guard let url = URL(string: GlobalIdentifier.getSearchMovie(search: searchString)) else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {  return  }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else { return }
            
            let decoder = JSONDecoder()
            guard let data = data else { return }
            do {
                self.searchMovies = try decoder.decode(Movie.self, from: data)
                DispatchQueue.main.async {[weak self] in
                    self?.save(movie: (self?.searchMovies)!)
                    self?.fetchMovies() // fetching from core data to load collection view
                }
            } catch {
                self.deleteAllRecords(entityName: "Movie")
                self.deleteAllRecords(entityName: "Search")
                self.searchResult = []
                DispatchQueue.main.async {[weak self] in
                    self?.collectionView.reloadData()
                }
                print("Something went wrong")
            }
        }
        task.resume()
    }
    
    func save(movie: Movie) { // Save the searched movies to Core data before listing to collection view
        // 1
        let managedContext = DatabaseController.getContext()
        
        // 2
        let movieInfoEntity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
        let searchInfoEntity = NSEntityDescription.entity(forEntityName: "Search", in: managedContext)!
        
        let movieInfo = NSManagedObject(entity: movieInfoEntity, insertInto: managedContext)
        // 3
        movieInfo.setValue(movie.response, forKeyPath: "response")
        movieInfo.setValue(movie.totalresults, forKeyPath: "totalresults")
        for movie in movie.search! {
            let searchInfo = NSManagedObject(entity: searchInfoEntity, insertInto: managedContext)
            searchInfo.setValue(movie.title, forKey: "title")
            searchInfo.setValue(movie.year, forKey: "year")
            searchInfo.setValue(movie.imdbid, forKey: "imdbid")
            searchInfo.setValue(movie.type, forKey: "type")
            searchInfo.setValue(movie.poster, forKey: "poster")
            movieInfo.setValue(searchInfo, forKey: "searchInfo")
            // 4
        }
        DatabaseController.saveContext()
    }
    
    func fetchMovies() {
        // fetching details from Core Data and convert it into Dictionary
        let managedContext = DatabaseController.getContext()
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Search")
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        do {
            print("Data Retrived from Context Successfully")
            searchResult = try managedContext.fetch(fetchRequest) as? [[String:String]]
            self.collectionView.reloadData()
        } catch {
            print("Failed")
        }
    }
    
    func deleteAllRecords(entityName : String) {
        // deleting entity records from Core Data
        let managedContext = DatabaseController.getContext()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try managedContext.execute(request)
            try managedContext.save()
            print("Data Deleted Successfully")
        } catch {
            print ("There was an error")
        }
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    // collection view delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchResult?.count != 0 {
            return searchResult?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath as IndexPath) as! MovieCollectionViewCell
        let searchModelObj = searchResult?[indexPath.row]
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 10
        cell.movieImage.downloaded(from: (searchModelObj?["poster"])!)
        cell.nameLabel.text = searchModelObj?["title"]
        cell.yearLabel.text = searchModelObj?["year"]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let searchModelObj = self.searchResult?[indexPath.row]
        let session = URLSession.shared
        guard let url = URL(string: GlobalIdentifier.getMovieDetail(imdbID: (searchModelObj?["imdbid"])!)) else { return }
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {  return  }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else { return }
            
            let decoder = JSONDecoder()
            guard let data = data else { return }
            do {
                self.movieDetail = try decoder.decode(MovieDetail.self, from: data)
                DispatchQueue.main.async {[weak self] in
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let movieDetailVC = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
                    movieDetailVC.movieDetail = self?.movieDetail
                    self?.navigationController?.pushViewController(movieDetailVC, animated: true)
                }
            } catch {
                print("Something went wrong")
            }
        }
        task.resume()
    }
}

extension HomeViewController : UISearchBarDelegate {
    // searchbar delegate methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text!.count == 0 {
            isSearch = false;
            self.deleteAllRecords(entityName: "Movie")
            self.deleteAllRecords(entityName: "Search")
            self.searchResult = []
            self.collectionView.reloadData()
        } else {
            self.deleteAllRecords(entityName: "Movie")
            self.deleteAllRecords(entityName: "Search")
            self.getMovies(searchBar.text!)
        }
        isSearch = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == " " {
            return false
        }
        return true
    }
}
