//
//  DetailViewController.swift
//  MovieSearch
//
//  Created by Apple on 17/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var MovieTitle: UILabel!
    @IBOutlet weak var thumnil: UIImageView!
    @IBOutlet weak var detailtext: UITextView!
    @IBOutlet weak var daterelease: UILabel!
    
    @IBOutlet weak var rating: UILabel!
    var movietitle1:String?
    var detailtxt:String?
    var date:String?
    var rateing:String?
    var image1 :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieTitle.text = movietitle1
        detailtext.text = detailtxt
        let baseUrl: String = "https://image.tmdb.org/t/p/w500"

        guard  let imageurl = URL(string: baseUrl + image1!) else{return}
        thumnil.setImageWith(imageurl)
        daterelease.text = date
        rating.text = rateing
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    

}
