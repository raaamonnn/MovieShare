//
//  MovieListViewController.swift
//  MovieShare
//
//  Created by Ramon Amini on 4/19/20.
//  Copyright © 2020 Ramon Amini. All rights reserved.
//

import UIKit
import TMDBSwift
import Firebase

class MovieListViewController: UITableViewController {
    var movies:[MovieDT] = []
    var upvotes:[Bool] = []
    var db:Firestore
    var uid:String = ""
    
    init(genre:Int, categoryNum:[Int], uid:String){
        db = Firestore.firestore()
        super.init(nibName: nil, bundle: nil)
        
        self.uid = uid
        TMDBConfig.apikey = "2278f6d6028ac95be0150ae6fa0a571f"
        
        GenresMDB.genre_movies(genreId: categoryNum[genre], include_adult_movies: true, language: "en") { [weak self] apiReturn, movieList in
            guard let self = self else {return}
            
            if let movies = movieList
            {
                for movie in movies
                {
                    print(movie.id)
                    self.movies.append(MovieDT(title: movie.title ?? "Missing Title", description: movie.overview ?? " ", releaseDate: movie.release_date ?? " ", stars: movie.vote_average ?? 0, id: movie.id ?? 0))
                }
            }
            
            // ADD RATINGS FROM FIRESTORE HERE
//            self.db.collection("Movies").getDocuments() { [weak self] (querySnapshot, err) in
//                guard let self = self else {return}
//
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    guard let snap = querySnapshot else {return}
//                    for document in snap.documents{
//                        let data = document.data()
//                        self.upvotes.append(data["upvotes"] as? Bool ?? true) //instead of cars we need to get the name from each movie
//                                            print(self.upvotes[0])
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        db = Firestore.firestore()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: MovieListCell.self), bundle: nil), forCellReuseIdentifier: "movies")
        let background = UIImageView(image: #imageLiteral(resourceName: "Background"))
        background.contentMode = .scaleAspectFill
        tableView.backgroundView = background
        tableView.backgroundView?.contentMode = .scaleAspectFill
        tableView.backgroundColor = UIColor.clear
        tableView.reloadData()
    }
}
extension MovieListViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movies") as! MovieListCell
        
        // ADD RATINGS FROM FIRESTORE HERE
        var rating = movies[indexPath.row].stars / 2
        
        
        switch rating{
            case -10000000 ..< 1:
            cell.bind(title: movies[indexPath.row].title, stars: #imageLiteral(resourceName: "Transparent 1 Star Image"))
            
            case 1 ..< 2:
            cell.bind(title: movies[indexPath.row].title, stars: #imageLiteral(resourceName: "Transparent 2 Star Image"))
            
            case 2 ..< 3:
            cell.bind(title: movies[indexPath.row].title, stars: #imageLiteral(resourceName: "Transparent 3 Star Image"))
            
            case 3 ..< 4:
            cell.bind(title: movies[indexPath.row].title, stars: #imageLiteral(resourceName: "Transparent 4 Star Image"))
            
            case 4 ..< 5:
                cell.bind(title: movies[indexPath.row].title, stars: #imageLiteral(resourceName: "Transparent 5 Star Image"))
    
        default:
            cell.bind(title: movies[indexPath.row].title, stars: #imageLiteral(resourceName: "ArrowUpPressed"))
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var rating = movies[indexPath.row].stars / 2
        var stars:UIImage
        
        switch rating{
        case -10000000 ..< 1:
            stars = #imageLiteral(resourceName: "Transparent 1 Star Image")
            
        case 1 ..< 2:
            stars = #imageLiteral(resourceName: "Transparent 2 Star Image")
            
        case 2 ..< 3:
            stars = #imageLiteral(resourceName: "Transparent 3 Star Image")
            
        case 3 ..< 4:
            stars = #imageLiteral(resourceName: "Transparent 4 Star Image")
            
        case 4 ..< 5:
            stars = #imageLiteral(resourceName: "Transparent 5 Star Image")
            
        default:
            stars = #imageLiteral(resourceName: "ArrowUpPressed")
        }
        
//        print(self.movies[indexPath.row].title)
        navigationController?.pushViewController(MovieTableViewController(movie: self.movies[indexPath.row], stars: stars, db: db, uuid: self.uid), animated: true)
    }
    
}

