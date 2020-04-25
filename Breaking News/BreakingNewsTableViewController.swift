//
//  BreakingNewsTableViewController.swift
//  Breaking News
//
//  Created by Carmel Braga on 4/24/20.
//  Copyright © 2020 Carmel Braga. All rights reserved.
//

import UIKit

class BreakingNewsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let initialSearchText = "COVID"

    var searchController: UISearchController!
    let dateFormatter = DateFormatter()
    
    var breakingNews: [BreakingNew]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        
        title = "Breaking News"
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        //searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        let editButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        searchController.searchBar.text = initialSearchText

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            
            NYTBreakingNews.search(searchText: searchText, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main) {
                (userInfo, breakingNews, errorString) in
                if errorString != nil {
                    self.breakingNews = nil
                } else {
                    self.breakingNews = breakingNews
                }
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breakingNews?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "breakingNewCell", for: indexPath)

        if let cell = cell as? BreakingNewsTableViewCell, let breakingNew = breakingNews?[indexPath.row] {
            if let imageUrl = URL(string: breakingNew.media.url),
            let imageData = try? Data(contentsOf: imageUrl) {
                cell.newsImageView.image = UIImage(data: imageData)
            }
            cell.titleLabel.text = breakingNew.title
            cell.bylineLabel.text = breakingNew.byline
            cell.sourceLabel.text = breakingNew.source
            cell.publishedDateLabel.text = "Published: " + dateFormatter.string(from: breakingNew.publicationDate)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showBreakingNewsSegue", sender: self)
    }

    @IBAction func editTable(_ sender: Any) {
        if (tableView.isEditing) {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let breakingNew = breakingNews?[sourceIndexPath.row] {
            breakingNews?.remove(at: sourceIndexPath.row)
           breakingNews?.insert(breakingNew, at: destinationIndexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            breakingNews?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BreakingNewUIViewController,
           let indexPath = tableView.indexPathForSelectedRow,
           let numReviews = breakingNews?.count,
           indexPath.row < numReviews,
           let breakingNew = breakingNews?[indexPath.row] {
                destination.breakingNew = breakingNew
        }
        searchController.dismiss(animated: true, completion: {})
    }
}

