//
//  PopularMovieViewController.swift
//  MovieSearch
//
//  Created by Apple on 18/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import MBProgressHUD
import AFNetworking


class PopularMovieViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var Popularcollection: UICollectionView!
    
    var TopMovieArr:[Model] = []

    
    
        override func viewDidLoad() {
        super.viewDidLoad()
            Popularcollection.delegate = self
            Popularcollection.dataSource = self
            fetchMovies(nil)
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TopMovieArr.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularviewcell", for: indexPath) as! PopularmovieCollectionViewCell
        
        
        
        
        let movie1 = TopMovieArr[indexPath.row]
        
        if let posterPath1 = movie1.posterPath {
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            let imageUrl = URL(string: baseUrl + posterPath1)
            cell.popularImg.setImageWith(imageUrl!)
            cell.populartitle.text = movie1.title
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
                cell.popularImg.alpha = 1.0
            })
            
            
        }
        
        return cell
    }
    
    func fetchMovies(_ refreshControl: UIRefreshControl?){
        let apiKey = "a2c2ec62069f1f18a3ca04ee1714efc0"
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    let movies: NSArray = (responseDictionary["results"] as? [NSDictionary])! as NSArray
                    for movie in movies {
                        
                        self.TopMovieArr.append(Model(json: (movie as? NSDictionary)!))
                        
                    }
                    
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if (refreshControl  != nil){
                        refreshControl!.endRefreshing()
                    }
                    
                    self.Popularcollection.reloadData()
                    
                }
            }
        })
        
        task.resume()
    }
    
    
    
    
    
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   

}
