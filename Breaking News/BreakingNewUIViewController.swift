//
//  BreakingNewUIViewController.swift
//  Breaking News
//
//  Created by Carmel Braga on 4/24/20.
//  Copyright © 2020 Carmel Braga. All rights reserved.
//

import UIKit

class BreakingNewUIViewController: UIViewController {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bylineLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!

     var breakingNew: BreakingNew?
       
       let dateFormatter = DateFormatter()

       override func viewDidLoad() {
           super.viewDidLoad()
           
           dateFormatter.dateStyle = .medium
           
           title = "Breaking News"

           if let breakingNew = breakingNew {
               titleLabel.text = breakingNew.title
               bylineLabel.text = breakingNew.byline
            publishedDateLabel.text = "Published: " + dateFormatter.string(from: breakingNew.publicationDate)
            abstractLabel.text = breakingNew.abstract
            if let imageUrl = URL(string: breakingNew.media.url),
                   let imageData = try? Data(contentsOf: imageUrl) {
                   newsImageView.image = UIImage(data: imageData)
               }
           }
       }

       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }

    @IBAction func read(_ sender: Any) {
        if let breakingNew = breakingNew,
                   let url = URL(string: breakingNew.url) {
                          if UIApplication.shared.canOpenURL(url) {
                              UIApplication.shared.open(url, options: [:], completionHandler: nil)
                          }
                  }
    }
    
       
    }
    
