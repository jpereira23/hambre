        
import UIKit
import CoreLocation


struct Coordinate
{
    var latitude : Double!
    var longitude : Double!
}


protocol RadiiDistancesDelegate{
    func placeFound(place: String, radiiDistances: RadiiDistances)
    func finishedQuerying(radiiDistances: RadiiDistances)
}

class RadiiDistances: NSObject {
    private var earthsRadius = 6378.1
    private var bearingUnitCircleRadians = [0, 30, 45, 60, 90, 120, 135, 150, 180, -30, -45, -60, -90, -120, -135, -150]
    private var arrayOfCoordinates = [Coordinate]()
    private var currentPlace : String! = "San Francisco, California"
    public var delegate : RadiiDistancesDelegate?
    private var confirmedIndex = 0
    private var distance : Double!
    private var latitude : Double!
    private var longitude : Double!
    private var nextCity = 0
    
    
    public init(latitude: Double, longitude: Double, distance: Double)
    {
        super.init()
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
    }
    
    public func calculateForDistance(distance: Double)
    {
        
        var aDistance = distance
        
        while aDistance != -10
        {
            self.distance = aDistance
            self.calculate()
            aDistance -= 10.0
        }
        for i in 0..<self.arrayOfCoordinates.count
        {
            self.convertCoordinatesToUserFriendly(coordinate: self.arrayOfCoordinates[i], index: i)
        }
    }
    
    private func calculate()
    {
        
        for degree in bearingUnitCircleRadians
        {
            let bearingRadians = Double(degree) * Double.pi / Double(180)
            let lat1 = self.latitude * Double.pi / 180
            let lon1 = self.longitude * Double.pi / 180
            
            let lat2 = asin(sin(lat1)*cos(self.distance/self.earthsRadius) + cos(lat1)*sin(self.distance/self.earthsRadius)*cos(bearingRadians))
            
            let lon2 = lon1 + atan2(sin(bearingRadians)*sin(self.distance/self.earthsRadius)*cos(lat1), cos(self.distance/self.earthsRadius)-sin(lat1)*sin(lat2))
            
            var aCoordinate = Coordinate()
            aCoordinate.longitude = lon2 * 180 / Double.pi
            aCoordinate.latitude = lat2 * 180 / Double.pi
            self.arrayOfCoordinates.append(aCoordinate)
        }
        
       
        
        
    }
    
    public func callDelegate()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.delegate?.placeFound(place: appDelegate.getCityAndState(), radiiDistances: self)
    }
    
    private func convertCoordinatesToUserFriendly(coordinate: Coordinate, index: Int)
    {
        let location = CLLocation(latitude: self.arrayOfCoordinates[index].latitude, longitude: self.arrayOfCoordinates[index].longitude)
        let geocoder = CLGeocoder()
        var compactString : String! = "N/A"
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark : CLPlacemark!
            placeMark = placemarks?[0]
            
            if let error = error
            {
                self.confirmedIndex += 1
                if self.confirmedIndex == (self.arrayOfCoordinates.count-1)
                {
                    self.delegate?.finishedQuerying(radiiDistances: self)
                }
                print("there was an error at index: \(index)")
            }
            if placeMark != nil
            {
                if let city = placeMark.addressDictionary?["City"] as? String {
                    compactString = city + ", "
                }
                if let state = placeMark.addressDictionary?["State"] as? String {
                    compactString = compactString + state
                }
                
                self.confirmedIndex += 1
                self.delegate?.placeFound(place: compactString, radiiDistances: self)
                if self.confirmedIndex == (self.arrayOfCoordinates.count-1)
                {
                    self.delegate?.finishedQuerying(radiiDistances: self)
                }
            }
           
        })
    }
}
