//
//  WeatherViewController.swift
//  WeatherStatus
//
//  Created by Vijay Singh on 25/07/16.
//  Copyright © 2016 Vijay Singh. All rights reserved.
//
import CoreLocation
import UIKit

class WeatherViewController: UIViewController, LocationManagerDelegate, UIAlertViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherTableView: UITableView!
    
    @IBOutlet weak var cityField: UITextField!
    var weatherItems = [WeatherData]()
    var isRequestInProgress : Bool = false // to stop other request, if one request is already running

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.startUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getWeatherForCity(cityName:String) {
        
        if !Utils.isNetworkReachable() {
            let alertView = UIAlertView(title: "No network in device", message: "It seems your device has no network access. Please check.", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
            return
        }
        self.activityIndicator.startAnimating()

        let model = WeatherModel()
        
        self.weatherItems.removeAll()
        
        isRequestInProgress = true
        weak var weakSelf = self
        model.fetchWeatherDataForCity(cityName) { (data, error) in
            if error == nil && data != nil {
                
                weakSelf!.weatherItems.appendContentsOf(data as! Array)
                weakSelf!.weatherTableView.reloadData()
            }
            else {
                let alertView = UIAlertView(title: "Weather fetching failed", message: "Try again after some time", delegate: nil, cancelButtonTitle: "Ok")
                alertView.show()
            }
            weakSelf!.isRequestInProgress = false
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK Tableview Datasource and Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.weatherItems.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : WeatherCell?
        cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell") as! WeatherCell?
        cell?.configCellWithData(self.weatherItems[indexPath.row])
        
        return cell!
    }


    @IBAction func refreshLocation(sender: AnyObject) {
        if self.isRequestInProgress {
            return
        }
        self.isRequestInProgress = true
        LocationManager.sharedInstance.startUpdatingLocation()
    }
    
    
    @IBAction func getWeather(sender: AnyObject) {
        if self.isRequestInProgress {
            return
        }

        self.view.endEditing(true)
        if cityField.text?.characters.count > 0 {
            self.getWeatherForCity(cityField.text!)
        }
        else {
            let alertView = UIAlertView(title: "No City", message: "Please enter city name", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
        }
    }
    
    // MARK LocationManagerDelegate method
    
    func fetchedLocation(cityName: String) {
        self.getWeatherForCity(cityName as String)
        cityField.text = cityName
    }
    
    func locationFetchingDidFailWithErrorType(error: ErrorType) {
        
        self.isRequestInProgress = false

        switch error {
            
        case .NotAuthorized:
            
            if #available(iOS 8.0, *) {
                let alertView = UIAlertView(title: "Location disabled", message: "Please give permission of location service from setting", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Setting") ;                alertView.show()
            }
            else {
                let alertView = UIAlertView(title: "Location disabled", message: "Please give permission of location service from setting", delegate: nil, cancelButtonTitle: "Ok")
                alertView.show()
            }
            
        case .OtherError:
            
        let alertView = UIAlertView(title: "Location determining failed", message: "Please check permission of location service in setting", delegate: nil, cancelButtonTitle: "Ok")
        alertView.show()
            
        case .NoNetworkError:
        
        let alertView = UIAlertView(title: "No network in device", message: "It seems your device has no network access. Please check.", delegate: nil, cancelButtonTitle: "Ok")
        alertView.show()
      }
         self.activityIndicator.stopAnimating()
    }
    

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if #available(iOS 8.0, *) {
                UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
            } else {
            }
        }
    }
}

