//
//  MovieListCell.swift
//  MovieShare
//
//  Created by Ramon Amini on 5/26/20.
//  Copyright © 2020 Ramon Amini. All rights reserved.
//

import UIKit

class MovieListCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var stars: UIImageView!
    
    func bind(title: String, stars: UIImage) {
        self.title.text = title
        self.stars.image = stars
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
    }
    
}
