//
//  MovieTableViewController.swift
//  MovieShare
//
//  Created by Ramon Amini on 5/28/20.
//  Copyright © 2020 Ramon Amini. All rights reserved.
//

import UIKit
import Firebase

class MovieTableViewController: UITableViewController {
    
    var movie:MovieDT = MovieDT()
    var stars:UIImage = #imageLiteral(resourceName: "5 Star")
    
    init(movie:MovieDT, stars:UIImage){
        super.init(nibName: nil, bundle: nil)
        self.movie = movie
        self.stars = stars
        
        
//        print(movie.description)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: MovieTableViewCell.self), bundle: nil), forCellReuseIdentifier: "movie")
        let background = UIImageView(image: #imageLiteral(resourceName: "Background"))
        tableView.backgroundView = background
        tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.reloadData()
    }
}
extension MovieTableViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie") as! MovieTableViewCell
        cell.bind(title: movie.title, stars: self.stars, releaseDate: movie.releaseDate, discription: movie.description)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.thumbsDown.tag = 5
        cell.thumbsUp.tag = 6
        cell.thumbsDown.isUserInteractionEnabled = true
        cell.thumbsUp.isUserInteractionEnabled = true
        let tapRecognizerThumbsUp = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.thumbsDown.addGestureRecognizer(tapRecognizerThumbsUp)
        let tapRecognizerThumbsDown = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.thumbsUp.addGestureRecognizer(tapRecognizerThumbsDown)
        return cell
    }
    
    // #4
    @objc func imageTapped(recognizer: UITapGestureRecognizer) {
        
        print(recognizer.view!.tag)
        if recognizer.view!.tag == 6 //thumbs up
        {
            
            let tapLocation = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.tableView.cellForRow(at: tapIndexPath) as? MovieTableViewCell {
                    if tappedCell.thumbsUp.image == #imageLiteral(resourceName: "ArrowUpPressed")
                    {
                        return
                    }
                    else
                    {
                        tappedCell.thumbsUp.image = #imageLiteral(resourceName: "ArrowUpPressed")
                        //&& add like to firestore
                        let db = Firestore.firestore()
                        //HOW DO I ANONYMOUSLY LOGIN USER 
                        
//                        db.collection("Movies").document("Naruto").updateData(["upvotes": FieldValue.increment(Int64(1))])
                    }
                }
        }
        else if recognizer.view!.tag == 5 //thumbs down
        {
            
        }
        
    }
        
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
}
