//
//  MCConstants.swift
//  MeetingCalendar
//
//  Created by Aarzoo Varshney on 13/09/19.
//  Copyright © 2019 Aarzoo Varshney. All rights reserved.
//

import Foundation

var workingStartTime = "9:00"
var workingEndTime = "17:00"

var slotIntervals: slotDifference = .halfHoured

enum slotDifference : Int{
    case halfHoured = 30, fullHoured = 60
}
