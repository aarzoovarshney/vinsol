//
//  SuggestionTableViewCell.swift
//  MeetingCalendar
//
//  Created by Aarzoo Varshney on 13/09/19.
//  Copyright © 2019 Aarzoo Varshney. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(slot : String){
        self.textLabel?.text = slot
    }
}
