//
//  MasterViewController.swift
//  U.S Presidents App
//
//  Created by Vanessa Aguilar on 10/28/20.
//  Copyright © 2020 Personal Team. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate,UISearchResultsUpdating {
  
    
    var detailViewController: DetailViewController? = nil
    var objects = [presidentInfo]()
    var filteredObjects = [presidentInfo]() //meets our reach criteria
    
    let imageStore = ImageStore()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        setUpSearchController()
        downloadJASONData()
    }

    
//MARK: - Dealing with search bar
    
    func setUpSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false //allows you to select item from new search results
        navigationItem.searchController = searchController //makes sure that the search bar does not overlap w/ data
        definesPresentationContext = true
        
        searchController.delegate = self
               
        //Scope bar buttons
            searchController.searchBar.scopeButtonTitles = ["All", "Democrat", "Republican", "Whig"]
        
        //creating that delegate for that search bar
        searchController.searchBar.delegate = self
    }
    
    //Utility Function that sort of lets you know if the search bar is empty or not
      func searchBarIsEmpty() -> Bool{
              ///if it is empty
              ///searchController.searchBar.text?.isEmpty  : that expression will return true
          ///??  : third case if there is no text for the search bar : return true if there is nothing in the text bar at all
          
          return searchController.searchBar.text?.isEmpty ?? true

      }
      //Utility Function for the search bar, lets you know if you are filtering results
      func isFiltering() -> Bool{
          ///If youve pressed any of the scope bar buttons other than "All": bc "All " is the default '0'
          ///To return true the search controller has to be active, they would have typed something in the text or pressed a button other
              ///than all
          let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
          return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
      }
      
    
      //Own function that will actually filter the array
      ///The goals is to get a subset of objects into filtered objects
      func filterContentForSearchText(_ searchText: String, scope: String = "All"){
          filteredObjects = objects.filter { character in
              let doesMatch = (scope == "All") || (character.politicalParty == scope)
      
              if searchBarIsEmpty(){
                  return doesMatch
              }else { ///returning true if the character name contains the letter
                  return doesMatch && character.name.lowercased().contains(searchText.lowercased())
              }
              
          }

          tableView.reloadData() //going to reload the table
          
      }
      

      func updateSearchResults(for searchController: UISearchController) {
          let searchBar = searchController.searchBar
          
          //figuring out whats the title of the current button that is selected , that will be scope
          let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
          filterContentForSearchText(searchBar.text!, scope: scope)
      }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
          filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
      
      }
//MARK: - JASON data handelers
    func downloadJASONData(){
        guard let url = URL(string: "https://www.prismnet.com/~mcmahon/CS321/presidents.json")
            else{
                showAlert("ERROR with JSON data")
                return
        }
        weak var weakSelf = self
     
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
        let httpResponse = response as? HTTPURLResponse
        if httpResponse!.statusCode != 200 {
        // Perform some error handling
        // UI updates, like alerts, should be directed to the main thread
        weakSelf!.showAlert( "HTTP Error: status code \(httpResponse!.statusCode)")
        } else if (data == nil && error != nil) {
                    // Perform some error handling
            weakSelf!.showAlert("No data downloaded")
        } else {
        // Download succeded, will put the things into the objects succesfully
         do {
                weakSelf!.objects = try JSONDecoder().decode([presidentInfo].self, from: data!)
                   //to sort the array, by short hand
                    weakSelf!.objects.sort{
                       return $0.number < $1.number //sort in ascending order by the name
                       //$0 & $1 are short hand for the two arguments that are being passed into the comparison function
                       
                   }
            //Telling the table view to reload its data with what you have downloaded
            DispatchQueue.main.async {
                weakSelf!.tableView!.reloadData()
            }
               }catch {
                    weakSelf!.showAlert("Unable to decode JSON data")
               }
        }
    }
        task.resume()
 
    
}
    
    ///displays an alert in case of an error
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "ERROR", message: message,preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        //Ensure we are doing this in the main thread
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
           
    
    }
    

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
          
                let object : presidentInfo
                if isFiltering(){
                    object = filteredObjects[indexPath.row]
                }else{
                    object = objects[indexPath.row]
                }
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.imageStore = imageStore //passing in the image store object we are creating in the masterVC
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredObjects.count
        }else{
            return objects.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! presidentCell
        let object : presidentInfo
        
        if isFiltering(){
            object = filteredObjects[indexPath.row]
        }else{
                    object = objects[indexPath.row]
        }
        ///downloading the image
        imageStore.downloadImage(with: object.imageUrlString, completion: {
            (image: UIImage?) in
            cell.presidentImageView.image = image
        })

        
        cell.nameLabel!.text = object.name
        cell.partyLabel!.text = object.politicalParty
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false //true , for edit capabilities
    }

  

}


