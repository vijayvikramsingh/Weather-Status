//
//  WeatherModel.swift
//  WeatherStatus
//
//  Created by Vijay Singh on 25/07/16.
//  Copyright © 2016 Vijay Singh. All rights reserved.
//

import UIKit

let APP_ID = "b3dd0a98a7911f0a453d24abd96973dd"

class WeatherModel: NSObject {

    let url = "http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=%@"
    
    func fetchWeatherDataForCity(cityName:String , completionBlock:(AnyObject? , NSError?) -> Void ) -> NSURLSessionDataTask? {
        
        var urlStr =  String(format:url,cityName,APP_ID)
        
        let httpSessionManager = AFHTTPSessionManager()
        let requestSerializer = AFHTTPRequestSerializer()
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        httpSessionManager.requestSerializer = requestSerializer
        
        urlStr = urlStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        
       // weak var weakSelf = self
        let onGoingTask : NSURLSessionDataTask? =  httpSessionManager.GET(urlStr, parameters: nil, progress: { (progress) in
            
            print("in progress")
            }, success: { (task, data) in
                
                completionBlock(self.getWeatherItemFromData(data!), nil)
                
                print("data found")
                
        }) { (task, error) in
            completionBlock(nil, error)
            print(error.description)
        }
        
        return onGoingTask
    }

    func getWeatherItemFromData(data:AnyObject) -> [WeatherData]? {
        
        guard data is Dictionary<String, AnyObject> else {
            return nil
        }
        var array = [WeatherData]()

        if let weather = data["weather"] as? [Dictionary<String, AnyObject>]{
             var weatherDetail = weather[0]
            let weatherD = WeatherData()
            weatherD.title = "Weather Status:"
            weatherD.value = "\(weatherDetail["description"]!)"
            array.append(weatherD)
        }
        
        if let main = data["main"] as? Dictionary<String, AnyObject>{
            
            let weatherData = WeatherData()
            weatherData.title = "Temprature:"
            weatherData.value = "\(main["temp"]!) Kelvin"
            array.append(weatherData)
           
            let weatherData1 = WeatherData()
            weatherData1.title = "Pressure:"
            weatherData1.value = "\(main["pressure"]!) hPA"
            array.append(weatherData1)
            
            let weatherData2 = WeatherData()
            weatherData2.title = "Humidity:"
            weatherData2.value = "\(main["humidity"]!)%"
            array.append(weatherData2)
        }
        if let wind = data["wind"] as? Dictionary<String, AnyObject> {
            
            let weatherData3 = WeatherData()
            weatherData3.title = "Wind Speed:"
            weatherData3.value = "\(wind["speed"]!) meter/sec"
            array.append(weatherData3)
        }
        
        if let rain = data["rain"] as? Dictionary<String, AnyObject> {
            
            let weatherData4 = WeatherData()
            weatherData4.title = "Rain:"
            weatherData4.value = "\(rain["3h"]!)"
            array.append(weatherData4)

        }
        if let clouds = data["clouds"] as? Dictionary<String, AnyObject> {
            
            let weatherData5 = WeatherData()
            weatherData5.title = "Clouds:"
            weatherData5.value = "\(clouds["all"]!)%"
            array.append(weatherData5)

        }
        if let snow = data["snow"] as? Dictionary<String, AnyObject> {
            
            let weatherData6 = WeatherData()
            weatherData6.title = "Snow:"
            weatherData6.value = "\(snow["3h"]!)%"
            array.append(weatherData6)

        }
     return array
    }
}
