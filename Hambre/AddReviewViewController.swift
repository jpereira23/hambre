
//
//  AddReviewViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/2/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class AddReviewViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var reviewSlider: UISlider!
    @IBOutlet weak var greetingField: UILabel!
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet var reviewStarOne: UIImageView!
    @IBOutlet var reviewStarTwo: UIImageView!
    @IBOutlet var reviewStarThree: UIImageView!
    @IBOutlet var reviewStarFour: UIImageView!
    @IBOutlet var reviewStarFive: UIImageView!
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var anonymousSwitch: UISwitch!
    private var canContinue = true
    
    private var review : Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        commentView.delegate = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([doneButton], animated: true)
        
        commentView.inputAccessoryView = toolbar
        self.usernameField.borderStyle = .none
        self.usernameField.backgroundColor = .white 
        
        self.title = "Add Review"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor.white]
        let firstStarRecognizer = UITapGestureRecognizer(target: self, action: #selector(firstStarTapped(tapGestureRecognizer:)))
        self.reviewStarOne.isUserInteractionEnabled = true
        self.reviewStarOne.addGestureRecognizer(firstStarRecognizer)
        let secondStarRecognizer = UITapGestureRecognizer(target: self, action: #selector(secondStarTapped(tapGestureRecognizer:)))
        self.reviewStarTwo.isUserInteractionEnabled = true
        self.reviewStarTwo.addGestureRecognizer(secondStarRecognizer)
        let thirdStarRecognizer = UITapGestureRecognizer(target: self, action: #selector(thirdStarTapped(tapGestureRecognizer:)))
        self.reviewStarThree.isUserInteractionEnabled = true
        self.reviewStarThree.addGestureRecognizer(thirdStarRecognizer)
        let fourthStarRecognizer = UITapGestureRecognizer(target: self, action: #selector(fourthStarTapped(tapGestureRecognizer:)))
        self.reviewStarFour.isUserInteractionEnabled = true
        self.reviewStarFour.addGestureRecognizer(fourthStarRecognizer)
        let fifthStarRecognizer = UITapGestureRecognizer(target: self, action: #selector(fifthStarTapped(tapGestureRecognizer:)))
        self.reviewStarFive.isUserInteractionEnabled = true
        self.reviewStarFive.addGestureRecognizer(fifthStarRecognizer)
        
        
        self.usernameField.delegate = self
        self.commentView.text = "Example: This has got to be my favorite burger place! Every time I come here, the customer service and quality of food never disappoint. I'm a huge burger fan, so my patties, fries, and bacon all have to be cooked perfect for me to enjoy a good meal, and truth is, this restaurant makes this all a reality."
        self.commentView.textColor = UIColor.lightGray
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.usernameField.frame
        rectShape.position = self.usernameField.center
        rectShape.path = UIBezierPath(roundedRect: self.usernameField.bounds, byRoundingCorners: [.topRight, .topLeft, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        self.usernameField.layer.mask = rectShape
        
    }
    
    func doneClicked()
    {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if self.usernameField.text == "e.i. John Smith"
        {
            self.usernameField.text = ""
            self.usernameField.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if self.commentView.text == "Example: This has got to be my favorite burger place! Every time I come here, the customer service and quality of food never disappoint. I'm a huge burger fan, so my patties, fries, and bacon all have to be cooked perfect for me to enjoy a good meal, and truth is, this restaurant makes this all a reality."
        {
            self.commentView.text = ""
            self.commentView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.usernameField.text == "" || self.usernameField.text == " "
        {
            self.usernameField.placeholder = "e.i. John Smith"
            self.usernameField.textColor = UIColor.lightGray
            
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.commentView.text == " "  || self.commentView.text == "" {
            self.commentView.text = "Example: This has got to be my favorite burger place! Every time I come here, the customer service and quality of food never disappoint. I'm a huge burger fan, so my patties, fries, and bacon all have to be cooked perfect for me to enjoy a good meal, and truth is, this restaurant makes this all a reality."
            self.commentView.textColor = UIColor.lightGray
        }
        
       
        
    }
    
    func firstStarTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.reviewStarThree.image = UIImage(named: "fullstar")
        self.reviewStarOne.image = UIImage(named: "fullstar")
        self.reviewStarTwo.image = UIImage(named: "graystar")
        self.reviewStarFour.image = UIImage(named: "graystar")
        self.reviewStarFive.image = UIImage(named: "graystar")
        self.review = 2
    }
 
    func secondStarTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.reviewStarOne.image = UIImage(named: "fullstar")
        self.reviewStarTwo.image = UIImage(named: "fullstar")
        self.reviewStarThree.image = UIImage(named: "fullstar")
        self.reviewStarFour.image = UIImage(named: "fullstar")
        self.reviewStarFive.image = UIImage(named: "fullstar")
        self.review = 5
    }
    
    func thirdStarTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.reviewStarThree.image = UIImage(named: "fullstar")
        self.reviewStarTwo.image = UIImage(named: "graystar")
        self.reviewStarOne.image = UIImage(named: "graystar")
        self.reviewStarFour.image = UIImage(named: "graystar")
        self.reviewStarFive.image = UIImage(named: "graystar")
        self.review = 1
        
    }
    
    func fourthStarTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        self.reviewStarThree.image = UIImage(named: "fullstar")
        self.reviewStarOne.image = UIImage(named: "fullstar")
        self.reviewStarFour.image = UIImage(named: "fullstar")
        self.reviewStarTwo.image = UIImage(named: "graystar")
        self.reviewStarFive.image = UIImage(named: "graystar")
        self.review = 3
        
        //
        
    }
    
    func fifthStarTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        self.reviewStarOne.image = UIImage(named: "fullstar")
        self.reviewStarFive.image = UIImage(named: "fullstar")
        self.reviewStarThree.image = UIImage(named: "fullstar")
        self.reviewStarFour.image = UIImage(named: "fullstar")
        self.reviewStarTwo.image = UIImage(named: "graystar")
        self.review = 4
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func switchWasTurnedOn(_ sender: Any)
    {
        if anonymousSwitch.isOn
        {
            usernameField.isEnabled = false
            self.usernameField.text = "Anonymous"
        }
        else
        {
            usernameField.isEnabled = true
            self.usernameField.text = "e.i. John Smith"
        }
    }
    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "fromAddReview"
        {
            if (usernameField.text == "e.i. John Smith") && review == 0 && !anonymousSwitch.isOn
            {
                let alert = UIAlertController(title: "Incomplete Review", message: "You must enter a username and select at least one star in order to submit.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    
                })
                
                
                self.present(alert, animated: true)
                return  false
            }
            else if (usernameField.text == "e.i. John Smith") && !anonymousSwitch.isOn
            {
                let alert = UIAlertController(title: "Incomplete Review", message: "You must enter a username or select to review anonomously in order to submit.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    
                })
                
                
                self.present(alert, animated: true)
                return false
            }
            else if review == 0
            {
                let alert = UIAlertController(title: "Incomplete Review", message: "You must select at least one star in order to submit.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    
                })
                
                
                self.present(alert, animated: true)
                return false
            }
        }
        return true
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromAddReview"
        {
            
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let businessViewController = segue.destination as! BusinessViewController
            let review = Review(id: businessViewController.getURL(), review: self.review, reviewer: (anonymousSwitch.isOn ? "Anonymous" : usernameField.text!), summaryReview: (self.commentView.text == "Example: This has got to be my favorite burger place! Every time I come here, the customer service and quality of food never disappoint. I'm a huge burger fan, so my patties, fries, and bacon all have to be cooked perfect for me to enjoy a good meal, and truth is, this restaurant makes this all a reality." ? "" : self.commentView.text))
            
            businessViewController.cloudKitDatabaseHandler.appendToArrayOfReviews(review: review)
            businessViewController.reviewMade = review
            
            
            businessViewController.cloudKitDatabaseHandler.addToDatabase(review: review)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    

}
