//
//  Utility.swift
//  WeatherStatus
//
//  Created by Vijay Singh on 27/07/16.
//  Copyright © 2016 Vijay Singh. All rights reserved.
//

import Foundation

class Utils {
    
 static func isNetworkReachable() ->Bool {
    let reachability = Reachability.reachabilityForInternetConnection()
    let netStatus = reachability.currentReachabilityStatus()
    
    return (netStatus == NotReachable) ? false : true
 }

}
    /*+(BOOL)isNetworkReachable
        {
            Reachability* reachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus netStatus = [reachability currentReachabilityStatus];
            
            return (netStatus == NotReachable) ? FALSE : TRUE;
 */
