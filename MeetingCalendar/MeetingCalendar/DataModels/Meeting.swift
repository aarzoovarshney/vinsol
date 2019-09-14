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
    var startTimeConverted : String
    var endTime : String
    var endTimeConverted : String
    var date : Date?
    
    init(responseDictionary:[String:AnyObject]?, date : String) {
        self.description = responseDictionary?["description"] as? String ?? ""
        self.startTime =  responseDictionary?["start_time"] as? String ?? ""
        self.endTime = responseDictionary?["end_time"] as? String ?? ""
        let attendeesArray = responseDictionary?["participants"] as? [String] ?? []
        for attendee in attendeesArray{
            attendees.append(User.init(name: attendee))
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let startTimeDate = dateFormatter.date(from: startTime)
        let endTimeDate = dateFormatter.date(from: endTime)
        dateFormatter.dateFormat = "h:mm a"
        self.startTimeConverted = dateFormatter.string(from: startTimeDate!)
        self.endTimeConverted = dateFormatter.string(from: endTimeDate!)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.date = dateFormatter.date(from: date)!
    }
}
