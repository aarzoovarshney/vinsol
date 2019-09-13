//
//  ScheduleMeetingViewController.swift
//  MeetingCalendar
//
//  Created by Aarzoo Varshney on 13/09/19.
//  Copyright © 2019 Aarzoo Varshney. All rights reserved.
//

import UIKit

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
    
    var startTimeArray = ["9:00","10:00","11:00","12:00","13:00","14:00","15:00"]
    var endTimeArray = ["9:00","10:00","11:00","12:00","13:00","14:00","15:00"]
    var selectedTime : Int = 0
    let startTimePicker = UIPickerView()
    let endTimePicker = UIPickerView()
    let startTimeToolBar = UIToolbar()
    let endTimeToolBar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
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
            print(self.view.frame)
            let height = (self.view.frame.size.height)
            let width = (self.view.frame.size.width)
            let constraint = height > width ? width : height
            meetingDateWidthConstraint.constant =  constraint - 20
            startTimeWidthConstraint.constant = constraint - 20
            endTimeWidthConstraint.constant = constraint - 20
        }
        
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        }    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == startTimePicker{
            startTimeTextFeild.text = startTimeArray[row]
        }
        else{
            endTimeTextFeild.text = endTimeArray[row]
        }
    }
}
