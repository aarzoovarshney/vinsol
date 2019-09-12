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
        self.navigationItem.title = date
        MCServiceManager().getRequest(url, parameters: parameter) { (isSuccess, response, error) in
            self.hideRefreshControl()
            if isSuccess{
                if let dictionaryArray = response as? [[String:Any]]{
                    for dictionary in dictionaryArray{
                        let meeting = Meeting.init(responseDictionary: dictionary as [String : AnyObject])
                        self.meetingArray.append(meeting)
                    }
                    self.meetingTableView.reloadData()
                }
            }
        }
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
        let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: myDate)
        return dateFormatter.string(from: tomorrow!)
    }
    
    func getNextDate(currentDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let myDate = dateFormatter.date(from: currentDate)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
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
    
    
}
