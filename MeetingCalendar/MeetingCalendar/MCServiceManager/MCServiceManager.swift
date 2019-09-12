//
//  MCServiceManager.swift
//  MeetingCalendar
//
//  Created by Aarzoo Varshney on 12/09/19.
//  Copyright © 2019 Aarzoo Varshney. All rights reserved.
//

import UIKit
import Alamofire

class MCServiceManager: NSObject {

    func getRequest(_ url : String, parameters : [String: Any]?,responseBlock:@escaping (_ status :Bool,  _ jsonResponse:AnyObject?, _ error:NSError?) -> Void ) {
        print("Request url--->",url)
        print("para---->",parameters)
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON{ response in
            switch response.result {
            case .success:
                print(response)
                responseBlock(true, response.result.value as AnyObject?, nil)
            case .failure:
                let error = response.result.error! as NSError
                print(error)
            }
        }
    }
}
