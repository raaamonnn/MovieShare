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
    var db:Firestore
    var movie:MovieDT = MovieDT()
    var stars:UIImage = #imageLiteral(resourceName: "5 Star")
    var uuid:String
    
    
    init(movie:MovieDT, stars:UIImage, db:Firestore, uuid:String){
        self.uuid = uuid
        self.db = db
        super.init(nibName: nil, bundle: nil)
        self.movie = movie
        self.stars = stars
    }
    
    required init?(coder aDecoder: NSCoder) {
        db = Firestore.firestore()
        uuid = "NSCODER"
        print(uuid)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: MovieTableViewCell.self), bundle: nil), forCellReuseIdentifier: "movie")
        let background = UIImageView(image: #imageLiteral(resourceName: "MovieBackground"))
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
        
        //CHECK IF UP OR DOWNVOTE HAS BEEN PRESSED BY USER IF SO MAKE UP/DOWN VOTE APPEAR
        cell.bind(movie: self.movie, stars: self.stars, db: self.db, uuid: self.uuid)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        //tapping recognization
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
    
    @objc func imageTapped(recognizer: UITapGestureRecognizer) {
        
        //UUID DOESNT GET DELETED THATS WHY BOTH ARROWS STAY TURNED ON
        //WHY DOES UUID NOT GET DELETED FROM delete()
        
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
                        //if user has already downvoted we need to reset the ui as well as firestore
                        if tappedCell.thumbsDown.image == #imageLiteral(resourceName: "ArrowDownPressed")
                        {
                            tappedCell.thumbsDown.image = #imageLiteral(resourceName: "ArrowDown") //reset image
                            db.collection("Movies").document(String(self.movie.id)).updateData(["downvoteCount": FieldValue.increment(Int64(-1))]) //take away the old downvote from firestore
                            db.collection("Movies").document(String(self.movie.id)).collection("Downvotes").document(self.uuid).delete(){ err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("Document successfully removed!")
                                }
                            }
                        }
                        
                        tappedCell.thumbsUp.image = #imageLiteral(resourceName: "ArrowUpPressed")
                        db.collection("Movies").document(String(self.movie.id)).updateData(["upvoteCount": FieldValue.increment(Int64(1))])
                        { err in //if the movie hasnt already been upvoted on
                            if err != nil{
                                self.db.collection("Movies").document(String(self.movie.id)).setData(["upvoteCount": FieldValue.increment(Int64(1))])
                            }
                        }
                        
                        db.collection("Movies").document(String(self.movie.id)).collection("Upvotes").document(String(self.uuid)).setData([" ":""])
                    }
                }
            }
        }
        else if recognizer.view!.tag == 5 //thumbs down
        {
            let tapLocation = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.tableView.cellForRow(at: tapIndexPath) as? MovieTableViewCell {
                    if tappedCell.thumbsDown.image == #imageLiteral(resourceName: "ArrowDownPressed")
                    {
                        return
                    }
                    else
                    {
                        //if user has already upvoted we need to reset the ui as well as firestore
                        if tappedCell.thumbsUp.image == #imageLiteral(resourceName: "ArrowUpPressed")
                        {
                            tappedCell.thumbsUp.image = #imageLiteral(resourceName: "ArrowUp") //reset image
                            db.collection("Movies").document(String(self.movie.id)).updateData(["upvoteCount": FieldValue.increment(Int64(-1))]) //take away the old upvote from firestore
                            db.collection("Movies").document(String(self.movie.id)).collection("Upvotes").document(self.uuid).delete(){ err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("Document successfully removed!")
                                }
                            }
                        }
                        
                        tappedCell.thumbsDown.image = #imageLiteral(resourceName: "ArrowDownPressed")
                        db.collection("Movies").document(String(self.movie.id)).updateData(["downvoteCount": FieldValue.increment(Int64(1))])
                        { err in //if the movie hasnt already been upvoted on
                            if err != nil{
                                self.db.collection("Movies").document(String(self.movie.id)).setData(["downvoteCount": FieldValue.increment(Int64(1))])
                            }
                        }
                        db.collection("Movies").document(String(self.movie.id)).collection("Downvotes").document(String(self.uuid)).setData([" ":""])
                    }
                }
            }
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
}
