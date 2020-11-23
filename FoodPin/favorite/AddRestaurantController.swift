//
//  AddRestaurantController.swift
//  FoodPin
//
//  Created by Apple on 11/11/20.
//

import UIKit
import CoreData

class AddRestaurantController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var typeTextField:UITextField!
    @IBOutlet var locationTextField:UITextField!
    @IBOutlet var yesButton:UIButton!
    @IBOutlet var noButton:UIButton!
    @IBOutlet var phoneTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var isVisited = true
    
    var restaurant:RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    // MARK: - Table view data source
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                imagePicker.delegate = self
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey  : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: photoImageView.superview, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: photoImageView.superview, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: photoImageView.superview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: photoImageView.superview, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveButton(_ sender: AnyObject) {
        if nameTextField.text == "" || typeTextField.text == "" || locationTextField.text == "" {
            let alertController = UIAlertController(title: "Fails", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            restaurant = RestaurantMO(context:
            appDelegate.persistentContainer.viewContext)
            restaurant.name = nameTextField.text
            restaurant.type = typeTextField.text
            restaurant.location = locationTextField.text
            restaurant.phone = phoneTextField.text
            restaurant.isVisited = isVisited
            if let restaurantImage = photoImageView.image {
                if let imageData = restaurantImage.pngData() {
                    restaurant.image = NSData(data: imageData) as Data
                    
                }
            }
            print("Saving data to context ...")
            appDelegate.saveContext()
        }
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func toggleBeenHereButton(sender: UIButton) {
        // Yes button clicked
        if sender == yesButton {
            isVisited = true
            
            // Change the backgroundColor property of yesButton to red
            yesButton.backgroundColor = UIColor(red: 218.0/255.0, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
            
            // Change the backgroundColor property of noButton to gray
            noButton.backgroundColor = UIColor(red: 218.0/255.0, green: 223.0/255.0, blue: 225.0/255.0, alpha: 1.0)
            
        } else if sender == noButton {
            isVisited = false
            
            // Change the backgroundColor property of yesButton to gray
            yesButton.backgroundColor = UIColor(red: 218.0/255.0, green: 223.0/255.0, blue: 225.0/255.0, alpha: 1.0)
            
            // Change the backgroundColor property of noButton to red
            noButton.backgroundColor = UIColor(red: 218.0/255.0, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        }
    }
}
