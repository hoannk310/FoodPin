//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Apple on 11/9/20.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phone
        case 4:
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = (restaurant.isVisited) ? "Yes, I've been here before. \(restaurant.rating ?? "")" : "No"

        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        cell.backgroundColor = UIColor.clear
        return cell
        
    }
    @IBOutlet var tableView:UITableView!
    @IBOutlet var restaurantImageView:UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantTypeLabel: UILabel!
    @IBOutlet weak var restaurantLocationLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var restaurant: RestaurantMO!
    var rating = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantImageView.image = UIImage(data: restaurant.image as! Data)
        //        restaurantNameLabel.text = restaurant.name
        //        restaurantLocationLabel.text  = restaurant.location
        //        restaurantTypeLabel.text = restaurant.type
        // Do any additional setup after loading the view.
        
        
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        title = restaurant.name
        navigationController?.hidesBarsOnSwipe = false
        
        
     
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!, completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
                if let placemarks = placemarks {
                    // Get the first placemark
                    let placemark = placemarks[0]
                    // Add annotation
                    let annotation = MKPointAnnotation()
                    if let location = placemark.location {
                        // Display the annotation
                        annotation.coordinate = location.coordinate
                        self.mapView.addAnnotation(annotation)
                        // Set the zoom level
                        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                        self.mapView.setRegion(region, animated: false)
                    }
            }

        })
        let tabImage = UITapGestureRecognizer(target: self, action: #selector(tabImage(tapGestureRecognizer:)))
        restaurantImageView.addGestureRecognizer(tabImage)
        restaurantImageView.isUserInteractionEnabled = true
        
        
    }
    @objc func tabImage(tapGestureRecognizer: UITapGestureRecognizer){
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let imageAction = UIAlertAction(title: "Edit image", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary

                imagePicker.delegate = self

                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        optionMenu.addAction(imageAction)
        optionMenu.addAction(cancelAction)
        present(optionMenu, animated: true, completion: nil)
    }
 
    @objc func showMap() {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey  : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            restaurantImageView.image = selectedImage
            restaurantImageView.contentMode = .scaleAspectFill
            restaurantImageView.clipsToBounds = true
        }
        let leadingConstraint = NSLayoutConstraint(item: restaurantImageView as Any, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: restaurantImageView.superview, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        let trailingConstraint = NSLayoutConstraint(item: restaurantImageView as Any, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: restaurantImageView.superview, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        let topConstraint = NSLayoutConstraint(item: restaurantImageView as Any, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: restaurantImageView.superview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        let bottomConstraint = NSLayoutConstraint(item: restaurantImageView as Any, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: restaurantImageView.superview, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
          
            if let restaurantImage = restaurantImageView.image {
                if let imageData = restaurantImage.pngData() {
                    restaurant.image = NSData(data: imageData) as Data
                }
            }
            print("Saving data to context ...")
            appDelegate.saveContext()
        }
        tableView.reloadData()
        
    }
    @IBAction func close(segue:UIStoryboardSegue) {
    }
    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue) {
        
        if let rating = segue.identifier {
            restaurant.isVisited = true
            switch rating {
            case "great": restaurant.rating = "Absolutely love it! Must try."
            case "good": restaurant.rating = "Pretty good."
            case "dislike": restaurant.rating = "I don't like it."
            default: break
            }
        }
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        
            appDelegate.saveContext()
        }
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReview" {
        let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
        } else if segue.identifier == "showMap" {
        let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
        }
    }
}
