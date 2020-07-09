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
    var db:Firestore
    var uid:String = ""
    var upvoteCount:[Int] = [] //if i actually wanna use this I need to store both the title and upvotecount since the async call returns it kinda randomly. Though I am not going to use the upvoteCount since it is impossible for me to add the average to the total that I get from the API.
    
    init(genre:Int, categoryNum:[Int], uid:String){
        db = Firestore.firestore()
        super.init(nibName: nil, bundle: nil)
        
        self.uid = uid
        TMDBConfig.apikey = "2278f6d6028ac95be0150ae6fa0a571f"
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.main.async
        {
            dispatchGroup.enter()
            GenresMDB.genre_movies(genreId: categoryNum[genre], include_adult_movies: true, language: "en") //first async call
            { [weak self] apiReturn, movieList in
                
                guard let self = self else {return}
                       
                if let movies = movieList
                {
                    for movie in movies
                    {
                        self.movies.append(MovieDT(title: movie.title ?? "Missing Title", description: movie.overview ?? " ", releaseDate: movie.release_date ?? " ", stars: movie.vote_average ?? 0, id: movie.id ?? 0))
                        
                        dispatchGroup.enter()
                        self.db.collection("Movies").document(String(movie.id)).getDocument() //second async call (multiple calls) -> this needs the first async call above to be finished
                        { [weak self] (querySnapshot, err) in
                            guard self == self else {return}
                            if let err = err {
                                print("Error getting documents: \(err)")
                                             }
                            else
                            {
                                guard let snap = querySnapshot else {return}
                                let data = snap.data()
                                self!.upvoteCount.append((data?["upvoteCount"] as? Int ?? 0) - (data?["downvoteCount"] as? Int ?? 0))
                                print(movie.title)
                                print((data?["upvoteCount"] as? Int ?? 0) - (data?["downvoteCount"] as? Int ?? 0))
                            }
                            dispatchGroup.leave()
                            self!.tableView.reloadData()
                        }
                    }
                }
                dispatchGroup.leave()
                self.tableView.reloadData()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("Async calls finished")
            self.tableView.reloadData()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        db = Firestore.firestore()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: MovieListCell.self), bundle: nil), forCellReuseIdentifier: "movies")
        let background = UIImageView(image: #imageLiteral(resourceName: "MoviesBackground"))
        background.contentMode = .scaleToFill
        tableView.backgroundView = background
        tableView.backgroundView?.contentMode = .scaleToFill
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
        
        let rating = movies[indexPath.row].stars / 2
        
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
        let rating = movies[indexPath.row].stars / 2
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
        
        navigationController?.pushViewController(MovieTableViewController(movie: self.movies[indexPath.row], stars: stars, db: db, uuid: self.uid), animated: true)
    }
    
}

