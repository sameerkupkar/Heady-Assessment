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
import PopOverMenu

class ViewController: UIViewController,UISearchBarDelegate,UIAdaptivePresentationControllerDelegate {

    @IBOutlet weak var filterbutton: UIBarButtonItem!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    let DetailSegueIdentifier = "DetailView"
    @IBOutlet weak var searchBar: UISearchBar!
    var movieModels: [Model] = []
    var filteredData: [Model]!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.returnKeyType = UIReturnKeyType.done
        filteredData = movieModels
        fetchMovies(nil)
        let barButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(ViewController.openMenu(sender:)))
        self.navigationItem.rightBarButtonItem = barButtonItem

        addUIRefreshControl()
        
    }

    
    @IBAction func FilterOption(_ sender: Any) {
        openMenu(sender: filterbutton)     

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        dismissKeyboard()
        
    
    }
    

    func dismissKeyboard() {
        
        searchBar.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
     
        filteredData = searchText.isEmpty ? movieModels : movieModels.filter({(movie: Model) -> Bool in
            return movie.title!.range(of: searchText, options: .caseInsensitive) != nil
        })
       collectionView.reloadData()
        
    }
    
    func fetchMovies(_ refreshControl: UIRefreshControl?){
        let apiKey = "a2c2ec62069f1f18a3ca04ee1714efc0"
      guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)") else {
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
            
            self.collectionView.reloadData()
            
           
                                                                    
                }
            }
        })
        task.resume()
        
    }


    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchMovies(refreshControl)
    }
    
    func addUIRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
    }
    

    public func openMenu(sender:UIBarButtonItem) {
        let titles1:NSArray = ["Popular", "Rated"]
        let descriptions:NSArray = ["Sort By popular", "Sort By high rated",]
        
        let popOverViewController = PopOverViewController.instantiate()
        popOverViewController.setTitles(titles1 as! Array<String>)
        popOverViewController.setDescriptions(descriptions as! Array<String>)
        
        popOverViewController.popoverPresentationController?.barButtonItem = sender
        popOverViewController.preferredContentSize = CGSize(width: 300, height:135)
         popOverViewController.presentationController?.delegate = self
        popOverViewController.completionHandler = { selectRow in
            switch (selectRow) {
            case 0:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "popularmovie") as! PopularMovieViewController
            self.present(nextVC, animated: true, completion: nil)


                break
            case 1:
                
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ratedmovie") as! RatedMovieViewController
                self.present(nextVC, animated: true, completion: nil)
                
                
                break
            
            default:
                break
            }
            
        };
        present(popOverViewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        let movie = filteredData[indexPath.row]
           cell.posterName.text = movie.title
        
        if let posterPath = movie.posterPath {
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            let imageUrl = URL(string: baseUrl + posterPath)
           
            cell.posterImage.setImageWith(imageUrl!)
            
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
                cell.posterImage.alpha = 1.0
            })
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: DetailSegueIdentifier) as! DetailViewController
        
        let movie = filteredData[indexPath.row]
        let moviename = movie.title!
        print("moviename\(moviename)")
        nextVC.movietitle1 = moviename
        nextVC.detailtxt = movie.overview
        nextVC.image1 = movie.posterPath!
        nextVC.date = movie.daterelease
        nextVC.rateing = String (describing: movie.vote!)
        self.present(nextVC, animated: true, completion: nil)

        
    }
    
    
    
    
   
    
    
}
