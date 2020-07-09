//
//  ViewController.swift
//  MovieShare
//
//  Created by Ramon Amini on 4/19/20.
//  Copyright © 2020 Ramon Amini. All rights reserved.
//
//
import UIKit
import TMDBSwift
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var categories:[String] = []
    var categoryNum:[Int] = []
    var uid:String = ""
    
    @IBOutlet var viewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = ["Action", "Adventure","Animation","Comedy","Crime","Documentary","Drama", "Family", "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller",  "War", "Western"]
        //used to fetch data from api
        categoryNum = [12, 28,16,35,80,99,18, 10751, 14, 36, 27, 10402, 9648, 10749, 878, 10770, 53, 10752, 37]
        self.viewController.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background"))
        //makes navbar seethrough
        UINavigationBar.appearance().isTranslucent = true
        tableView.backgroundColor = UIColor.clear
        
        //anonymously signs in every user to keep track of uuid's
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let user = authResult?.user else { return }
            let isAnonymous = user.isAnonymous  // true
            let uid = user.uid
            self.uid = uid
        }
    }
}

    extension ViewController: UITableViewDataSource, UITableViewDelegate{
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Make the navigation bar background clear
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Restore the navigation bar to default
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryCell
            cell.setCell(category: categories[indexPath.row])
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 130
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            navigationController?.pushViewController(MovieListViewController(genre: indexPath.row, categoryNum: categoryNum, uid: self.uid), animated: true)
        }
    }
