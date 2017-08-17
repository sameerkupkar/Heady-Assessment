//
//  ViewController.swift
//  MovieSearch
//
//  Created by Apple on 16/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import MBProgressHUD
import AFNetworking

class ViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    let DetailSegueIdentifier = "DetailView"
    @IBOutlet weak var searchBar: UISearchBar!
    var movieModels: [Model] = []
    var filteredData: [Model]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.returnKeyType = UIReturnKeyType.done
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        filteredData = movieModels
        fetchMovies(nil)
        
        addUIRefreshControl()
        
    }

    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        dismissKeyboard()
        //searchBar.resignFirstResponder()
    
    }
    

    func dismissKeyboard() {
        // add self
        searchBar.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){ // called when text changes (including clear)
     
        filteredData = searchText.isEmpty ? movieModels : movieModels.filter({(movie: Model) -> Bool in
            return movie.title!.range(of: searchText, options: .caseInsensitive) != nil
        })
       collectionView.reloadData()
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return filteredData.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
//        let movie = filteredData[indexPath.row]
//        
//        //cell.posterName.text = "Jatin\(indexPath.item)"
//        if let posterPath = movie.posterPath {
//            let baseUrl = "https://image.tmdb.org/t/p/w500"
//             let title1 = movie.title
//            print("Title\(title1)")
//            cell.posterName.text = movie.title
//            // let rate = movie.vote
//            //print("RATE\(rate)")
//            let imageUrl = URL(string: baseUrl + posterPath)
//            // print("ImageURl\(imageUrl)")
//            cell.posterImage.setImageWith(imageUrl!)
//            //cell.posterImage.setImageWith(imageUrl!)
//            UIView.animate(withDuration: 1.0, animations: {() -> Void in
//                cell.posterImage.alpha = 1.0
//            })
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        let cell: CollectionViewCell? = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
////        //self.posterImage = cell!.posterImage.image
//        print("KAI BE")
//        //self.performSegue(withIdentifier: DetailSegueIdentifier , sender:self )
//    }
//    
//    
//    
    func fetchMovies(_ refreshControl: UIRefreshControl?){
        let apiKey = "cfb5050c94f86d1d8e3c763105e05fd3"
      guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&page=1&page=2") else {
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request,
                                                         completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
        if let responseDictionary = try! JSONSerialization.jsonObject(
            with: data, options:[]) as? NSDictionary {
        let movies: NSArray = (responseDictionary["results"] as? [NSDictionary])! as NSArray
                for movie in movies {
                self.movieModels.append(Model(json: (movie as? NSDictionary)!))
                                                                    }
                                                                    
        self.filteredData = self.movieModels
        MBProgressHUD.hide(for: self.view, animated: true)
            
        if (refreshControl  != nil){
            refreshControl!.endRefreshing()
                }
                                                                //self.tableView.reloadData()
            self.collectionView.reloadData()
            
           
                                                                    
                }
            }
        })
        task.resume()
        //task.resume()
    }


    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchMovies(refreshControl)
    }
    
    func addUIRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        //tableView.insertSubview(refreshControl, at: 0)
    }
    


}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        let movie = filteredData[indexPath.row]

        //cell.posterName.text = "Jatin\(indexPath.item)"
        if let posterPath = movie.posterPath {
            let baseUrl = "https://image.tmdb.org/t/p/w500"
           // let title1 = movie.title
            //print("Title\(title1)")
            cell.posterName.text = movie.title
           // let rate = movie.vote
            //print("RATE\(rate)")
            let imageUrl = URL(string: baseUrl + posterPath)
           // print("ImageURl\(imageUrl)")
            cell.posterImage.setImageWith(imageUrl!)
            //cell.posterImage.setImageWith(imageUrl!)
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
                cell.posterImage.alpha = 1.0
            })
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: DetailSegueIdentifier) as! DetailViewController
        //nextVC.yourVariable = cell.theInfoYouWhatToPass
        let movie = filteredData[indexPath.row]
        let moviename = movie.title!
        print("moviename\(moviename)")
        nextVC.movietitle1 = moviename
       // self.navigationController?.pushViewController(nextVC, animated: true)
        nextVC.detailtxt = movie.overview
        nextVC.image1 = movie.posterPath!
        nextVC.date = movie.daterelease
        nextVC.rateing = String (describing: movie.vote!)
        self.present(nextVC, animated: true, completion: nil)
       print("KAI BE PRINT")

        
    }
    
    
    
    
   
    
    
}
