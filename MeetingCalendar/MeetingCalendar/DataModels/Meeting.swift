//
//  Meeting.swift
//  MeetingCalendar
//
//  Created by Aarzoo Varshney on 12/09/19.
//  Copyright © 2019 Aarzoo Varshney. All rights reserved.
//

import Foundation
import UIKit

class Meeting{
    var description : String
    var attendees = [User]()
    var startTime : String
    var endTime : String
    
    init(responseDictionary:[String:AnyObject]?) {
        self.description = responseDictionary?["description"] as? String ?? ""
        self.startTime =  responseDictionary?["start_time"] as? String ?? ""
        self.endTime = responseDictionary?["end_time"] as? String ?? ""
        let attendeesArray = responseDictionary?["participants"] as? [String] ?? []
        for attendee in attendeesArray{
            attendees.append(User.init(name: attendee))
        }
    }
}
