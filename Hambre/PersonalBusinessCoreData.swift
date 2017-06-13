//
//  PersonalBusinessCoreData.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/30/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreData

class PersonalBusinessCoreData: NSObject {
    private var managedObjects = [NSManagedObject]()
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var managedContext : NSManagedObjectContext!
    private var entity: NSEntityDescription!
    
    public override init()
    {
        self.managedContext = self.appDelegate.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: "PersonalBusinessData", in: self.managedContext)
    }
    
    public func saveBusiness(personalBusiness: PersonalBusiness)
    {
        let aBusiness = NSManagedObject(entity: self.entity!, insertInto: self.managedContext)
        
        aBusiness.setValue(personalBusiness.getBusinessName(), forKeyPath:"businessName")
        aBusiness.setValue(personalBusiness.getCity(), forKeyPath: "city")
        aBusiness.setValue(personalBusiness.getState(), forKeyPath: "state")
        let aString = personalBusiness.getBusinessImage().absoluteString
        aBusiness.setValue(aString, forKeyPath: "businessUrl")
        aBusiness.setValue(personalBusiness.getLiked(), forKeyPath: "liked")
        aBusiness.setValue(personalBusiness.getLikes(), forKeyPath: "likes")
        aBusiness.setValue(personalBusiness.getLongitude(), forKeyPath: "longitude")
        aBusiness.setValue(personalBusiness.getLatitude(), forKeyPath: "latitude")
        aBusiness.setValue(personalBusiness.getNumber(), forKeyPath: "phoneNumber")
        
        aBusiness.setValue(personalBusiness.getAddress(), forKeyPath: "address")
        
        aBusiness.setValue(personalBusiness.getIsClosed(), forKeyPath: "isClosed")
        aBusiness.setValue(personalBusiness.getWebsiteUrl(), forKeyPath: "websiteUrl")
        
        do
        {
            try self.managedContext.save()
            managedObjects.append(aBusiness)
        } catch let error as NSError {
            print("Couldnt not save. \(error). \(error.userInfo)")
        }
    }
    
    func loadCoreData() -> [PersonalBusiness]
    {
        var temporaryBusiness : [PersonalBusiness] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PersonalBusinessData")
        
        do {
            managedObjects = try self.managedContext!.fetch(fetchRequest)
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for businesses in managedObjects
        {
            let businessName = businesses.value(forKeyPath: "businessName") as! String
            let businessUrl = businesses.value(forKeyPath: "businessUrl") as! String
            let city = businesses.value(forKeyPath: "city") as! String
            let state = businesses.value(forKeyPath: "state") as! String
            let liked = businesses.value(forKeyPath: "liked") as! Bool
            let likes = businesses.value(forKeyPath: "likes") as! Int
            let latitude = businesses.value(forKeyPath: "latitude") as! Float
            let longitude = businesses.value(forKeyPath: "longitude") as! Float
            let aUrl = URL(string: businessUrl)
            let aPhone = businesses.value(forKeyPath: "phoneNumber") as! String
            
            let address = businesses.value(forKeyPath: "address") as! String
            
            let isClosed = businesses.value(forKeyPath: "isClosed") as! Bool
            
            let websiteUrl = businesses.value(forKeyPath: "websiteUrl") as! String
            
            let personalBusiness = PersonalBusiness(businessName: businessName, businessImageUrl: aUrl!, city: city, state: state, liked: liked, likes: likes, longitude: Double(longitude), latitude: Double(latitude), phoneNumber: aPhone, theAddress: address, isClosed: isClosed, websiteUrl: websiteUrl)
            
            
            temporaryBusiness.append(personalBusiness)
        }
        
        return temporaryBusiness
    }
    
    // Returns true if it is a duplicate
    public func checkForDuplicates(personalBusiness: PersonalBusiness) -> Bool
    {
        let array = self.loadCoreData()
        
        for business in array
        {
            if personalBusiness.getBusinessImage() == business.getBusinessImage()
            {
                return true
            }
        }
        return false
    }
    public func resetCoreData()
    {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonalBusinessData")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            _ = try self.managedContext.execute(request) 
        } catch let error as NSError {
            print("Could not save. \(error). \(error.userInfo)")
        }
    }

}