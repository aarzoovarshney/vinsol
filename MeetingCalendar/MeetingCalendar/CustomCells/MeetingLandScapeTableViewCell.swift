//
//  MeetingLandScapeTableViewCell.swift
//  MeetingCalendar
//
//  Created by Aarzoo Varshney on 12/09/19.
//  Copyright © 2019 Aarzoo Varshney. All rights reserved.
//

import UIKit

class MeetingLandScapeTableViewCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var attendeeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(meeting : Meeting){
        self.startTimeLabel.text = meeting.startTimeConverted
        self.endTimeLabel.text = meeting.endTimeConverted
        self.descriptionLabel.text = meeting.description
        self.attendeeLabel.text = meeting.attendees.compactMap{$0.name}.joined(separator: ", ")
    }
    
}
