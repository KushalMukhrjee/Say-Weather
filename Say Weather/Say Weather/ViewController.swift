//
//  ViewController.swift
//  Say Weather
//
//  Created by Kushal on 16/11/18.
//  Copyright © 2018 Kushal. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate {
    var flag=0
    
    var locationManager=CLLocationManager()
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var weatherOutlet: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherOutlet.isHidden=true
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate=self
            locationManager.desiredAccuracy=kCLLocationAccuracyBest
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sayWeather(_ sender: UIButton) {
        let session = URLSession.shared
        let city=textField.text?.uppercased()
        print(city)
        let weatherUrl = URL(string:  "http://api.openweathermap.org/data/2.5/weather?q=\(city!),in?&units=imperial&APPID=aeeed94a96013f85857502616707d896")
        print(weatherUrl)
//        if(weatherUrl==nil){
//            print("HEre")
//            var alert=UIAlertController(title: "Invalid City", message: "Please enter a valid city name in India", preferredStyle: .alert)
//            present(alert, animated: true, completion: nil)
//        }
       
            print("Here also")
        session.dataTask(with: weatherUrl!) { (data:Data?, response:URLResponse?, error:Error?) in
            let dataString = String(data: data!, encoding: String.Encoding.utf8)
            print(dataString)
            do{
                let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                let jsonDict=jsonObj?.value(forKey: "main") as? NSDictionary
                if(jsonDict==nil){
//                    var alert=UIAlertController(title: "Invalid City", message: "Please enter a valid city name in India", preferredStyle: .alert)
//                                self.present(alert, animated: true, completion: nil)
                    self.flag=1
                            }
                
            else{
                let temp=jsonDict?.value(forKey: "temp")
                
                let temp1=temp as? Double
                print(type(of: temp1))
                print("Temp in \(city) is:",temp!)
                
//
                DispatchQueue.main.async {
                    let tempC = Float(((temp1)! - 32)*(5/9))
                    print(tempC)
                    self.weatherOutlet.text="Temperature in \(city!) is: \(tempC)°C"
                    self.weatherOutlet.sizeToFit()
                    self.weatherOutlet.isHidden=false
                    self.textField.text=""
                    self.flag=0
                    
//                    self.weatherOutlet.text="HI"
                }
               
                
            }
                DispatchQueue.main.async {
                    if(self.flag==1){
                        self.textField.text=""
                        var alert=UIAlertController(title: "Invalid City", message: "Please enter a valid city name in India", preferredStyle: .alert)
                        var alertButton=UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(alertButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            
        
            catch{
                print(Error.self)
            }
        
        }.resume()
        
        
        
        
    }
    @IBAction func getCurrentLocation(_ sender: UIButton) {
//        print("Here")
//        print(locationManager.location)
        
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to get location")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("lat:",locations.last?.coordinate.latitude)
        print("long:",locations.last?.coordinate.longitude)
    }
    
    
}

