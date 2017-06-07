//
//  BusinessTileViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class BusinessTileViewController: UIViewController {

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var distanceField: UILabel!
    @IBOutlet var infoButton: UIButton!
    
    var aBusinessTileOperator : BusinessTileOperator! = nil
    let yelpContainer = YelpContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.businessImage.isHidden = true
        self.businessNameLabel.isHidden = true
        self.leftButton.isEnabled = false
        self.rightButton.isEnabled = false
        self.infoButton.isEnabled = false
        self.activityIndicator.startAnimating()
        
        yelpContainer.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "fromTileView"
        {
            let navigationViewController = segue.destination as! UINavigationController
            
            let navBar = navigationViewController.navigationBar
            
            /*
             let backItem = UIBarButtonItem()
             backItem.title = "Back"
             navigationViewController.navigationItem.backBarButtonItem = backItem
             */
            
            navBar.topItem?.title = self.aBusinessTileOperator.presentCurrentBusiness().getBusinessName()
            navBar.tintColor = UIColor.white
            navBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20.0), NSForegroundColorAttributeName: UIColor.white]
            
            //navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            navBar.barTintColor = UIColor(red: 252/255, green: 193/255, blue: 61/255, alpha: 1)
            let businessViewController = segue.destination.childViewControllers[0] as! BusinessViewController
            businessViewController.setIdentifier(id: "fromTileView")
            
            businessViewController.setUrl(aUrl: self.aBusinessTileOperator.presentCurrentBusiness().getBusinessImage())
            businessViewController.setLongitude(longitude: self.aBusinessTileOperator.presentCurrentBusiness().getLongitude())
            businessViewController.setLatitude(latitude: self.aBusinessTileOperator.presentCurrentBusiness().getLatitude())
        }
    }
    
    
    @IBAction func swipeLeft(_ sender: Any) {
        self.aBusinessTileOperator.swipeLeft()
        self.refreshTileAttributes()
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        self.aBusinessTileOperator.swipeRight()
        self.refreshTileAttributes()
    }
    
    public func refreshTileAttributes()
    {
        let aBusiness = self.aBusinessTileOperator.presentCurrentBusiness()
        
        self.businessNameLabel.text = aBusiness.getBusinessName()
        self.businessImage.setImageWith(aBusiness.getBusinessImage())
        self.businessImage.contentMode = UIViewContentMode.scaleAspectFit
        self.distanceField.text = String(aBusiness.getDistance()) + " mile(s)"
    }

}

extension BusinessTileViewController : YelpContainerDelegate
{
    func yelpAPICallback(_ yelpContainer: YelpContainer) {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.businessImage.isHidden = false
        self.businessNameLabel.isHidden = false
        self.leftButton.isEnabled = true
        self.rightButton.isEnabled = true
        self.infoButton.isEnabled = true
        self.aBusinessTileOperator = BusinessTileOperator(anArrayOfBusinesses: yelpContainer.getBusinesses(), city: yelpContainer.getCity(), state: yelpContainer.getState())
        self.refreshTileAttributes()
        
    }
}
