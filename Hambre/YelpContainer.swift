//
//  YelpContainer.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/30/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import YelpAPI
import BrightFutures
import CloudKit


protocol CloudKitYelpApiDelegate
{
    func errorUpdating(_ error: NSError)
    func modelUpdated(cloudKitYelpApi: CloudKitYelpApi)
}

class YelpKeys: NSObject
{
    private var record: CKRecord!
    private weak var database: CKDatabase!
    private var appId: String!
    private var appSecret: String!
    
    init(record: CKRecord, database: CKDatabase)
    {
        self.record = record
        self.database = database
        
        self.appId = record["appId"] as! String
        self.appSecret = record["appSecret"] as! String
        
    }
    
    public func getAppId() -> String
    {
        return self.appId
    }
    
    public func getAppSecret() -> String
    {
        return self.appSecret
    }
}

class CloudKitYelpApi: NSObject
{
    let container : CKContainer!
    let publicDB : CKDatabase!
    
    private weak var database: CKDatabase!
    private var yelpKey : YelpKeys!
    var delegate: CloudKitYelpApiDelegate?
    
    public override init()
    {
        self.container = CKContainer.default()
        self.publicDB = container.publicCloudDatabase
        self.yelpKey = nil
        super.init()
        self.loadKeysFromCloudKit()
    }
    
    public func loadKeysFromCloudKit()
    {
        let aPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "YelpKeys", predicate: aPredicate)
        
        self.publicDB.perform(query, inZoneWith: nil) { results, error in
            if let error = error
            {
                DispatchQueue.main.async {
                    self.delegate?.errorUpdating(error as NSError)
                    print("Cloud Query Error - Fetch YelpKeys: \(error)")
                }
                return
            }
            results?.forEach({ (record: CKRecord) in self.yelpKey = YelpKeys(record: record, database: self.publicDB)
            })
            DispatchQueue.main.async {
                self.delegate?.modelUpdated(cloudKitYelpApi: self)
            }
        }
    }
    
    public func getAppId() -> String
    {
        return self.yelpKey.getAppId()
    }
    
    public func getAppSecret() -> String
    {
        return self.yelpKey.getAppSecret()
    }
}

@objc protocol YelpContainerDelegate
{
    func yelpAPICallback(_ yelpContainer: YelpContainer)
}

class YelpContainer: NSObject, CLLocationManagerDelegate {
    private var arrayOfBusinesses = [YLPBusiness]()
    private var city: String = "Tracy"
    private var state: String = "CA"
    private var location : String!
    private var appId = "M8_cEGzomTyCzwz3BDYY4Q"
    private var appSecret = "9zi4Z5OMoP2NJMVKjLE5Yk0AzquHDWyIYgbblBaTW3sumGzu6LJZcJUdcMa1GfKD"
    private var cloudKitYelpApi = CloudKitYelpApi()
    private var genre = "restaurants"
    var delegate : YelpContainerDelegate!
    
    public override init()
    {
        super.init()
        //self.configureCityAndStateWithCoordinate()
        self.location = self.createLocation()
        self.cloudKitYelpApi.delegate = self
        self.cloudKitYelpApi.loadKeysFromCloudKit()
    }
    
    public func setAppId(appId: String)
    {
        self.appId = appId
    }
    
    public func setAppSecret(appSecret: String)
    {
        self.appSecret = appSecret
    }
    
    public func changeGenre(genre: String)
    {
        self.genre = genre
        self.yelpAPICallForBusinesses()
    }
    
    public func yelpAPICallForBusinesses()
    {
        // API Call below
        var query : YLPQuery
        self.location = self.createLocation()
        query = YLPQuery(location: self.location)
        query.term = self.genre
        query.limit = 50
        YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
            client.search(withQuery: query)
            }.onSuccess { search in
                //Fix this, bad practice
                if let _ = search.businesses.last {
                    self.arrayOfBusinesses = search.businesses
                    self.delegate.yelpAPICallback(self)
                    /*
                     for aBusiness in search.businesses
                     {
                     print("Name: \(aBusiness.name) \n Image: \(String(describing: aBusiness.imageURL))")
                     
                     }
                     */
                } else {
                    print("No businesses found")
                }
                
            }.onFailure { error in
                print("Search errored: \(error)")
        }
    }
    
    public func getLocation() -> String
    {
        return self.location
    }
    
    public func getBusinesses() -> [YLPBusiness]
    {
        return self.arrayOfBusinesses
    }
    
    public func getCity() -> String
    {
        return self.city
    }
    
    public func getState() -> String
    {
        return self.state
    }
    
    //Everything below needs to remain private 
    
    private func configureCoordinates() -> CLLocationCoordinate2D
    {
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        return locationManager.location!.coordinate
    }
    
    private func configureCityAndStateWithCoordinate()
    {
        //let locValue = self.configureCoordinates()
        /*
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark : CLPlacemark!
            placeMark = placemarks?[0]
            
            if let state = placeMark.addressDictionary?["State"] as? String {
                self.state = state
                print("State: \(state)")
            }
            
            if let city = placeMark.addressDictionary?["City"] as? String {
                self.city = city
                print("City: \(city)")
                
            }
            
        })
        */

    }
    
    private func createLocation() -> String
    {
        let coreDataLocation = CoreDataLocation()
        
        if !coreDataLocation.checkIfCoreDataIsEmpty()
        {
            return coreDataLocation.loadLocation() 
        }
        return self.city + ", " + self.state
    }
    
    
}

extension YelpContainer : CloudKitYelpApiDelegate
{
    func errorUpdating(_ error: NSError)
    {
        print("Shit dont work")
    }
    
    func modelUpdated(cloudKitYelpApi: CloudKitYelpApi) {
        print("So far so good")
        self.setAppId(appId: cloudKitYelpApi.getAppId())
        self.setAppSecret(appSecret: cloudKitYelpApi.getAppSecret())
        self.yelpAPICallForBusinesses()
    }
}
