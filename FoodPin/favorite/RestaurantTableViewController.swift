//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Apple on 11/8/20.
//

import UIKit
import CoreData
class RestaurantTableViewController: UITableViewController,NSFetchedResultsControllerDelegate,UISearchResultsUpdating {
    
    var restaurants: [RestaurantMO] = []
    
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    
    var seachController: UISearchController!
    
    var seachResults: [RestaurantMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.hidesBarsOnSwipe = true
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        seachController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = seachController.searchBar
        seachController.searchResultsUpdater = self
        seachController.dimsBackgroundDuringPresentation = false
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        // Configure the cell...
        let restaurant = (seachController.isActive) ? seachResults[indexPath.row] : restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        cell.thumbnailImageView.image = UIImage(data: restaurant.image!)
        cell.thumbnailImageView.layer.cornerRadius = 30.0
        cell.thumbnailImageView.clipsToBounds = true
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
        return cell
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            } default:
                tableView.reloadData() }
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func filterController(for seachText: String) {
        seachResults = restaurants.filter({(restaurant)-> Bool in
            
            if let name = restaurant.name,let location = restaurant.location {
                let isMatch = name.localizedCaseInsensitiveContains(seachText)||location.localizedCaseInsensitiveContains(seachText)
                return isMatch
            }
            return false
        })
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let seachText = seachController.searchBar.text{
            filterController(for: seachText)
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if seachController.isActive {
            return false
        }else{
            return true
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if seachController.isActive {
            return seachResults.count
        } else{
            return restaurants.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Share", handler: {(action, indexPath) -> Void in
            let defaultText = "Chia sẻ " + self.restaurants[indexPath.row].name!
            if let imageToShare = UIImage(data: self.restaurants[indexPath.row].image!) {
                let activityController = UIActivityViewController(activityItems:
                                                                    [defaultText, imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil) }
        })
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Delete",handler: { (action, indexPath) -> Void in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDele = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDele)
                appDelegate.saveContext()
            }
        })
        
        shareAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        return [deleteAction,shareAction]
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indextPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as!RestaurantDetailViewController
                destinationController.restaurant = (seachController.isActive) ? seachResults[indextPath.row] : restaurants[indextPath.row]
            }
        }
    }
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
    }
}
