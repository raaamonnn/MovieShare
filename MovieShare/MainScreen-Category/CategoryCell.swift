//
//  CustomTableViewCell.swift
//  LearningTableViews
//
//  Created by Anoop tomar on 2/8/18.
//  Copyright © 2018 Devtechie. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var category: UILabel!
    
    func setCell(category:String) {
        self.category.text = category
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
        
        self.category.text = nil
        
    }
    
}
