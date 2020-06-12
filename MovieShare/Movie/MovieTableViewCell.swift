//
//  MovieTableViewCell.swift
//  MovieShare
//
//  Created by Ramon Amini on 5/30/20.
//  Copyright © 2020 Ramon Amini. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
        
    @IBOutlet var title: UILabel!
    @IBOutlet var stars: UIImageView!
    @IBOutlet var thumbsUp: UIImageView!
    @IBOutlet var thumbsDown: UIImageView!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var discription: UILabel!
    //@IBOutlet var picture: UIImageView!
    
    func bind(title: String, stars: UIImage, releaseDate: String, discription: String) {
            self.title.text = title
            self.stars.image = stars
            self.releaseDate.text = releaseDate
            self.discription.text = discription
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
