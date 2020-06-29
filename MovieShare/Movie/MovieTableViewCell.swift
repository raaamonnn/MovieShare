//
//  MovieTableViewCell.swift
//  MovieShare
//
//  Created by Ramon Amini on 5/30/20.
//  Copyright © 2020 Ramon Amini. All rights reserved.
//

//LAST STEP IS TO ADD THE UP/DOWN VOTES TO EACH MOVIE FROM FIRESTORE

import UIKit
import Firebase

class MovieTableViewCell: UITableViewCell {
        
    @IBOutlet var title: UILabel!
    @IBOutlet var stars: UIImageView!
    @IBOutlet var thumbsUp: UIImageView!
    @IBOutlet var thumbsDown: UIImageView!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var discription: UILabel!
    
    func bind(movie: MovieDT, stars: UIImage, db: Firestore, uuid: String) {
        self.title.text = movie.title
            self.stars.image = stars
        self.releaseDate.text = movie.releaseDate
        self.discription.text = movie.description
        
        //Checking if the user has already upvoted
        db.collection("Movies").document(String(movie.id)).collection("Upvotes").document(uuid).getDocument { (document, error) in
            if let document = document, document.exists {
                print("DOCUMENT HAS BEEN UPVOTED BY USER")

                self.thumbsUp.image = #imageLiteral(resourceName: "ArrowUpPressed")
                
            } else {
                print("Document does not exist")
            }
        }
        
        //Checking if the user has already downvoted
        
        db.collection("Movies").document(String(movie.id)).collection("Downvotes").document(uuid).getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("DOCUMENT HAS BEEN DOWNVOTED BY USER")
                
                self.thumbsDown.image = #imageLiteral(resourceName: "ArrowDownPressed")
            } else {
                print("Document does not exist")
            }
        }
        
        }
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            // Configure the view for the selected state
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            self.stars.image = nil
            self.title.text = nil
            self.releaseDate.text = nil
            self.discription.text = nil
        }
}
