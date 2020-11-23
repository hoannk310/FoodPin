//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Apple on 11/10/20.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    var restaurant:RestaurantMO?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let restaurant = restaurant, let restaurantImage = restaurant.image {
            restaurantImageView.image = UIImage(data: restaurantImage as Data)
        }
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
