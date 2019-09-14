//
//  ScheduleMeetingViewController.swift
//  MeetingCalendar
//
//  Created by Aarzoo Varshney on 13/09/19.
//  Copyright © 2019 Aarzoo Varshney. All rights reserved.
//

import UIKit
import PSTAlertController

class ScheduleMeetingViewController: UIViewController {
    @IBOutlet weak var endTimeViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var meetingDateWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var startTimeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var endTimeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var meetingDateView: UIView!
    @IBOutlet weak var startTimeView: UIView!
    @IBOutlet weak var endTimeView: UIView!
    @IBOutlet weak var descriptionTextview: UITextView!
    @IBOutlet weak var meetingDateLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var startTimeTextFeild: UITextField!
    @IBOutlet weak var endTimeTextFeild: UITextField!
    
    let picker = UIPickerView()
    var meetingDate: String = "Meeting Date"
    var startTimeArray = ["8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00","24:00"]
    var endTimeArray = ["9:00","10:00","11:00","12:00","13:00","14:00","15:00"]
    
    var startTimeDateArray = [Date]()
    var endTimeDateArray = [Date]()
    
    var bookedStartTimeArray = [String]()
    var bookedEndTimeArray = [String]()
    var selectedTime : Int = 0
    let startTimePicker = UIPickerView()
    let endTimePicker = UIPickerView()
    let startTimeToolBar = UIToolbar()
    let endTimeToolBar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        convertTime()
        createPicker()
        createToolbar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        configureViews()
    }
    
    func configureViews(){
        if UIDevice.current.orientation.isLandscape {
            endTimeViewTopConstraint.constant = -50
            let height = (self.view.frame.size.height)
            let width = (self.view.frame.size.width)
            let constraint = height < width ? width : height
            meetingDateWidthConstraint.constant = (constraint / 2) - 20
            startTimeWidthConstraint.constant = (constraint / 2) - 20
            endTimeWidthConstraint.constant = (constraint / 2) - 20
        } else {
            endTimeViewTopConstraint.constant = 10
            let height = (self.view.frame.size.height)
            let width = (self.view.frame.size.width)
            let constraint = height > width ? width : height
            meetingDateWidthConstraint.constant =  constraint - 20
            startTimeWidthConstraint.constant = constraint - 20
            endTimeWidthConstraint.constant = constraint - 20
        }
        
        meetingDateLabel.text = meetingDate
        
        submitButton.backgroundColor = UIColor.init(red: 0, green: 165/255, blue: 134/255, alpha: 1.0)
        submitButton.layer.cornerRadius = 5.0
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        
        meetingDateView.layer.cornerRadius = 5.0
        startTimeView.layer.cornerRadius = 5.0
        endTimeView.layer.cornerRadius = 5.0
        descriptionTextview.layer.cornerRadius = 5.0
        
        meetingDateView.layer.borderWidth = 1.0
        startTimeView.layer.borderWidth = 1.0
        endTimeView.layer.borderWidth = 1.0
        descriptionTextview.layer.borderWidth = 1.0
        
        meetingDateView.layer.borderColor = UIColor(white: 211/255, alpha: 1.0).cgColor
        startTimeView.layer.borderColor = UIColor(white: 211/255, alpha: 1.0).cgColor
        endTimeView.layer.borderColor = UIColor(white: 211/255, alpha: 1.0).cgColor
        descriptionTextview.layer.borderColor = UIColor(white: 211/255, alpha: 1.0).cgColor
        
        switch slotIntervals {
        case slotDifference.halfHoured:
            startTimeArray = ["8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30","24:00"]
            endTimeArray = ["8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30","24:00"]
        default:
            startTimeArray = ["8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00","24:00"]
            endTimeArray = ["8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00","24:00"]
        }
    }
    
    func convertTime(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        startTimeDateArray.removeAll()
        endTimeDateArray.removeAll()
        for time in bookedStartTimeArray{
            let timeDate = dateFormatter.date(from: time)
            startTimeDateArray.append(timeDate!)
        }
        for time in bookedEndTimeArray{
            let timeDate = dateFormatter.date(from: time)
            endTimeDateArray.append(timeDate!)
        }
    }

    func createPicker() {
        startTimePicker.delegate = self
        startTimeTextFeild.inputView = startTimePicker
        
        endTimePicker.delegate = self
        endTimeTextFeild.inputView = endTimePicker
    }
    
    
    func createToolbar() {
        startTimeToolBar.sizeToFit()
        let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        startTimeToolBar.setItems([doneButton1], animated: false)
        startTimeToolBar.isUserInteractionEnabled = true
        startTimeTextFeild.inputAccessoryView = startTimeToolBar
        
        endTimeToolBar.sizeToFit()
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))

        endTimeToolBar.setItems([doneButton2], animated: false)
        endTimeToolBar.isUserInteractionEnabled = true
        endTimeTextFeild.inputAccessoryView = endTimeToolBar
    }
    
    func showAlertMessage(_ title:String, message: String){
        if(PSTAlertController.hasVisibleAlertController() == true){
            return
        }
        let alertController = PSTAlertController(title: title, message: message, preferredStyle: PSTAlertControllerStyle.alert)
        alertController.addAction(PSTAlertAction(title: "OK", style: PSTAlertActionStyle.default, handler: nil))
        alertController.showWithSender(nil, controller: nil, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        if selectedTime == 0{
            startTimeTextFeild.text = startTimeArray[startTimePicker.selectedRow(inComponent: 0)]
        }
        else{
            endTimeTextFeild.text = endTimeArray[endTimePicker.selectedRow(inComponent: 0)]
        }
        
        view.endEditing(true)
    }
    
    func validateTime() -> Bool{
        let startTime = startTimeTextFeild.text ?? ""
        let endTime = endTimeTextFeild.text ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let startTimeDate = dateFormatter.date(from: startTime){
            if let endTimeDate = dateFormatter.date(from: endTime){
                if startTimeDate >= endTimeDate{
                    showAlertMessage("Warning...!!", message: "Start time should be less than end time.")
                    return false
                }
                else{
                    if (checkAvailability(startDate: startTimeDate, endDate: endTimeDate)){
                        showAlertMessage("Hurray...!!", message: "Meeting slot of " + startTime + " - " + endTime + " booked")
                    }
                    else{
                        let cal = Calendar.current
                        let components = cal.dateComponents([.minute], from: startTimeDate, to: endTimeDate)
                        let diffMin = components.minute!
                        showSuggestions(slotDuration: diffMin)
                    }
                }
            }
        }
        
      return true
    }
    
    func showSuggestions(slotDuration : Int){
        
        let suggestionVC = self.storyboard?.instantiateViewController(withIdentifier: "SuggestionViewController") as! SuggestionViewController
        suggestionVC.slotDuration = slotDuration
        suggestionVC.startTimeDateArray = self.startTimeDateArray
        suggestionVC.endTimeDateArray = self.endTimeDateArray
        self.navigationController?.pushViewController(suggestionVC, animated: true)
    }
    
    func checkAvailability(startDate: Date, endDate: Date) -> Bool{
        var isAvailable = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let workingStartTimeDate = dateFormatter.date(from: workingStartTime){
            if let workingEndTimeDate = dateFormatter.date(from: workingEndTime){
                if startDate >= workingStartTimeDate && endDate <= workingEndTimeDate{
                    for i in 0..<startTimeDateArray.count{
                        if (startDate >= startTimeDateArray[i] && startDate < endTimeDateArray[i]) || (endDate > startTimeDateArray[i] && endDate <= endTimeDateArray[i]){
                            isAvailable = false
                            return isAvailable
                        }
                        else if (startTimeDateArray[i] >= startDate && startTimeDateArray[i] < endDate) || (endTimeDateArray[i] >= startDate && endTimeDateArray[i] < endDate){
                            isAvailable = false
                            return isAvailable
                        }
                    }
                }
                else{
                    showAlertMessage("Warning...!!", message: "Meeting slot is not in office hours. It must be between " + workingStartTime + " - " + workingEndTime)
                    isAvailable = false
                    return isAvailable
                }
            }
        }
      return isAvailable
    }
    
    @IBAction func pickStartTime(_ sender: Any) {
        startTimeTextFeild.becomeFirstResponder()
        selectedTime = 0
    }
    
    @IBAction func pickEndTime(_ sender: Any) {
        endTimeTextFeild.becomeFirstResponder()
        selectedTime = 1
    }
    
    @IBAction func scheduleMeeting(_ sender: Any) {
        validateTime()
    }
}

extension ScheduleMeetingViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == startTimePicker{
            return startTimeArray.count
        }
        else{
            return endTimeArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == startTimePicker{
            return startTimeArray[row]
        }
        else{
            return endTimeArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == startTimePicker{
            selectedTime = 0
        }
        else{
            selectedTime = 1
        }
    }
}
