//
//  MeetingPotraitTableViewCell.swift
//  MeetingCalendar
//
//  Created by Aarzoo Varshney on 12/09/19.
//  Copyright © 2019 Aarzoo Varshney. All rights reserved.
//

import UIKit

class MeetingPotraitTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(meeting: Meeting){
        self.timeLabel.text = meeting.startTimeConverted + " - " + meeting.endTimeConverted
        self.descriptionLabel.text = meeting.description
    }
}
