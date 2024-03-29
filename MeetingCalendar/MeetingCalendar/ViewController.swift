//
//  ViewController.swift
//  MeetingCalendar
//
//  Created by Aarzoo Varshney on 12/09/19.
//  Copyright © 2019 Aarzoo Varshney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var meetingTableView: UITableView!

    var refreshControl: UIRefreshControl?
    var meetingArray = [Meeting]()
    var date = "7-7-2015"
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday
    }
    var workingHours : Int = 0
    enum slotInterval: String {
        case halfHour, fullHour
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date = dateToString(date: Date())
        configureNavBar()
        configureRefreshControl()
        registerCell()
        configureTableview()
        refresh()
    }
    
    func configureRefreshControl (){
        refreshControl = UIRefreshControl()
        meetingTableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    }
    
    @objc func refresh(){
        refreshControl?.beginRefreshing()
        fetchMeetings()
    }
    
    func hideRefreshControl(){
        refreshControl?.endRefreshing()
    }
    
    func configureNavBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0, green: 165/255, blue: 134/255, alpha: 1.0)
        self.navigationItem.title = date
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let prevButton = UIButton.init(type: .custom)
        prevButton.setImage(#imageLiteral(resourceName: "backChevron"), for: .normal)
        prevButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 44)
        prevButton.addTarget(self, action: #selector(self.prevTapped), for: .touchUpInside)
        prevButton.setTitle("Prev", for: .normal)
        let prev = UIBarButtonItem.init(customView: prevButton)
        navigationItem.leftBarButtonItem = prev
        
        let nextButton = UIButton.init(type: .custom)
        nextButton.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24)
        nextButton.setImage(#imageLiteral(resourceName: "backChevron"), for: .normal)
        nextButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        nextButton.setTitle("Next", for: .normal)
        nextButton.imageView?.transform = (nextButton.imageView?.transform.rotated(by: CGFloat(Double.pi)))!
        nextButton.addTarget(self, action: #selector(self.nextTapped), for: .touchUpInside)
        
        let settingButton = UIButton.init(type: .custom)
        settingButton.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        settingButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 44)
        settingButton.addTarget(self, action: #selector(self.showSettings), for: .touchUpInside)
        
        let settings = UIBarButtonItem.init(customView: settingButton)
        let next = UIBarButtonItem.init(customView: nextButton)
        navigationItem.setRightBarButtonItems([settings, next], animated: false)
    }

    func registerCell(){
        meetingTableView?.register(UINib(nibName: "MeetingLandScapeTableViewCell", bundle: nil), forCellReuseIdentifier: "MeetingLandScapeTableViewCell")
        meetingTableView?.register(UINib(nibName: "MeetingPotraitTableViewCell", bundle: nil), forCellReuseIdentifier: "MeetingPotraitTableViewCell")
    }
    
    func configureTableview(){
        meetingTableView.dataSource = self
        meetingTableView.delegate = self
        meetingTableView?.rowHeight = UITableView.automaticDimension
        meetingTableView?.estimatedRowHeight = 50.0
        meetingTableView.separatorColor = UIColor.init(white: 169/255, alpha: 1.0)
        meetingTableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func fetchMeetings(){
        let url = "https://fathomless-shelf-5846.herokuapp.com/api/schedule"
        let parameter = ["date":date]
        self.meetingArray.removeAll()
        self.meetingTableView.reloadData()
        if UIDevice.current.orientation.isLandscape {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let myDate = dateFormatter.date(from: date)!
            dateFormatter.dateFormat = "EEEE"
            let dayOfTheWeekString = dateFormatter.string(from: myDate)
            self.navigationItem.title = dayOfTheWeekString + ", " + date
        }
        else{
            self.navigationItem.title = date
            
        }
        MCServiceManager().getRequest(url, parameters: parameter) { (isSuccess, response, error) in
            self.hideRefreshControl()
            self.removePlaceholderView()
            if isSuccess{
                if let dictionaryArray = response as? [[String:Any]]{
                    for dictionary in dictionaryArray{
                        let meeting = Meeting.init(responseDictionary: dictionary as [String : AnyObject], date: self.date)
                        self.meetingArray.append(meeting)
                    }
                    if self.meetingArray.count > 0{
                        let sortedArray = self.meetingArray.sorted { $0.startTime.localizedStandardCompare($1.startTime) == .orderedAscending }
                        self.meetingArray.removeAll()
                        self.meetingArray = sortedArray
                    }
                    else{
                        self.showPlaceholderView()
                    }
                    self.meetingTableView.reloadData()
                }
            }
        }
    }
    
    
    fileprivate func showPlaceholderView() {

        let customView = UIView(frame: CGRect(x: 0, y: 200, width: self.meetingTableView.frame.width, height: 50))
        customView.backgroundColor = UIColor.init(white: 237/255, alpha: 1.0)
        let label = UILabel.init(frame: CGRect.init(x: 70, y: 0, width: self.meetingTableView.frame.width - 20, height: 50))
        label.text = "No meetings scheduled yet."
        customView.addSubview(label)
        customView.tag = 100
        view.addSubview(customView)
    }
    
    fileprivate func removePlaceholderView(){
        let errorViews = view.subviews.filter { $0.tag == 100 }
        errorViews.map{ $0.removeFromSuperview() }
    }
    
    @objc func prevTapped(){
        date = getPrevDate(currentDate: date)
        refresh()
    }
    
    @objc func nextTapped(){
        date = getNextDate(currentDate: date)
        refresh()
    }
    
    @objc func showSettings(){
        
    }
    
    func getPrevDate(currentDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let myDate = dateFormatter.date(from: currentDate)!
        var tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: myDate)
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: tomorrow!)
        switch weekDay {
        case 1://sunday
            tomorrow = Calendar.current.date(byAdding: .day, value: -3, to: myDate)
        case 7://saturday
            tomorrow = Calendar.current.date(byAdding: .day, value: -2, to: myDate)
        default:
            print("weekday")
        }
        return dateFormatter.string(from: tomorrow!)
    }
    
    func getNextDate(currentDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let myDate = dateFormatter.date(from: currentDate)!
        var tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: tomorrow!)
        switch weekDay {
        case 1://sunday
            tomorrow = Calendar.current.date(byAdding: .day, value: 2, to: myDate)
        case 7://saturday
            tomorrow = Calendar.current.date(byAdding: .day, value: 3, to: myDate)
        default:
            print("weekday")
        }
        
        return dateFormatter.string(from: tomorrow!)
    }
    
    func dateToString(date: Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        meetingTableView.reloadData()
        if UIDevice.current.orientation.isLandscape {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let myDate = dateFormatter.date(from: date)!
            dateFormatter.dateFormat = "EEEE"
            let dayOfTheWeekString = dateFormatter.string(from: myDate)
            self.navigationItem.title = dayOfTheWeekString + ", " + date
        }
        else{
            self.navigationItem.title = date

        }
        
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UIDevice.current.orientation.isLandscape {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingLandScapeTableViewCell", for: indexPath) as! MeetingLandScapeTableViewCell
            cell.configureCell(meeting: meetingArray[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingPotraitTableViewCell", for: indexPath) as! MeetingPotraitTableViewCell
            cell.configureCell(meeting: meetingArray[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.meetingTableView.frame.width, height: 100))
        customView.backgroundColor = UIColor.init(white: 237/255, alpha: 1.0)
        let button = UIButton(frame: CGRect(x: 10, y: 0, width: self.meetingTableView.frame.width - 20, height: 50))
        button.backgroundColor = UIColor.init(red: 0, green: 165/255, blue: 134/255, alpha: 1.0)
        button.layer.cornerRadius = 5.0
        button.setTitle("Schedule Company Meeting", for: .normal)
        button.addTarget(self, action: #selector(self.scheduleMeeting), for: .touchUpInside)
        customView.addSubview(button)
        return customView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func scheduleMeeting(){
        let scheduleMeetingVC = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleMeetingViewController") as! ScheduleMeetingViewController
        scheduleMeetingVC.meetingDate = self.date
        scheduleMeetingVC.bookedStartTimeArray = self.meetingArray.map({ (meeting) -> String in
            return meeting.startTime
        })
        scheduleMeetingVC.bookedEndTimeArray = self.meetingArray.map({ (meeting) -> String in
            return meeting.endTime
        })
        self.navigationController?.pushViewController(scheduleMeetingVC, animated: true)
    }
    
}
