//
//  SuggestionViewController.swift
//  MeetingCalendar
//
//  Created by Aarzoo Varshney on 13/09/19.
//  Copyright © 2019 Aarzoo Varshney. All rights reserved.
//

import UIKit

class SuggestionViewController: UIViewController {

    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var slotDuration : Int = 60 //in minutes
    var startTimeDateArray = [Date]()
    var endTimeDateArray = [Date]()
    var suggestiveSlots = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableview()
        findSuggestiveSlots()
    }
    
    func configureTableview(){
        suggestionTableView.dataSource = self
        suggestionTableView.delegate = self
        suggestionTableView?.rowHeight = UITableView.automaticDimension
        suggestionTableView?.estimatedRowHeight = 50.0
        suggestionTableView.separatorColor = UIColor.init(white: 169/255, alpha: 1.0)
        suggestionTableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func findSuggestiveSlots(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let workingStartTimeDate = dateFormatter.date(from: workingStartTime)
        let workingEndTimeDate = dateFormatter.date(from: workingEndTime)
        
        let cal = Calendar.current
        var components = cal.dateComponents([.minute], from: workingStartTimeDate!, to: startTimeDateArray.first!)
        var diffMin = components.minute!
        if diffMin >= slotDuration{
            let numberOfSlots = diffMin/slotDuration
            for j in 1...numberOfSlots{
                let startSlotTime = Calendar.current.date(byAdding: .minute, value: -(slotDuration * (numberOfSlots - j + 1)), to: startTimeDateArray.first!)
                let endSlotTime = Calendar.current.date(byAdding: .minute, value: slotDuration * j, to: workingStartTimeDate!)
                suggestiveSlots.append( formatter.string(from: startSlotTime!) + " - " + formatter.string(from: endSlotTime!))
            }
        }
        
        for i in 0..<(startTimeDateArray.count - 1){
            components = cal.dateComponents([.minute], from: endTimeDateArray[i], to: startTimeDateArray[i+1])
            diffMin = components.minute!
            if diffMin >= slotDuration{
                let numberOfSlots = diffMin/slotDuration
                for j in 1...numberOfSlots{
                    let startSlotTime = Calendar.current.date(byAdding: .minute, value: -(slotDuration * (numberOfSlots - j + 1)), to: startTimeDateArray[i+1])
                    let endSlotTime = Calendar.current.date(byAdding: .minute, value: slotDuration * j, to: endTimeDateArray[i])
                    suggestiveSlots.append( formatter.string(from: startSlotTime!) + " - " + formatter.string(from: endSlotTime!))
                }
            }
        }
        
        components = cal.dateComponents([.minute], from: endTimeDateArray.last!, to: workingEndTimeDate!)
        diffMin = components.minute!
        if diffMin >= slotDuration{
            let numberOfSlots = diffMin/slotDuration
            for j in 1...numberOfSlots{
                let startSlotTime = Calendar.current.date(byAdding: .minute, value: -(slotDuration * (numberOfSlots - j + 1)), to: workingEndTimeDate!)
                let endSlotTime = Calendar.current.date(byAdding: .minute, value: slotDuration * j, to: endTimeDateArray.last!)
                suggestiveSlots.append( formatter.string(from: startSlotTime!) + " - " + formatter.string(from: endSlotTime!))
            }
        }
        suggestionTableView.reloadData()
        if suggestiveSlots.count == 0{
            messageLabel.text = "No slot available...!!"
            suggestionTableView.isHidden = true
        }
    }
}

extension SuggestionViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestiveSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = suggestionTableView.dequeueReusableCell(withIdentifier: "SuggestionTableViewCell", for: indexPath) as! SuggestionTableViewCell
        cell.configureCell(slot: suggestiveSlots[indexPath.row])
        return cell
    }
}
