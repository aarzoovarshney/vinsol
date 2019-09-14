    import UIKit
    let formatter  = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let todayDate = formatter.date(from: "2019-09-15")
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: todayDate!)
    print( weekDay)
    
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let dayOfTheWeekString = dateFormatter.string(from: todayDate!)
