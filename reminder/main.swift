//
//  main.swift
//  reminder
//
//  Created by kekeke on 2018/08/21.
//  Copyright © 2018 yksoft. All rights reserved.
//

import Foundation
import EventKit

func addReminder(title:String,alarmDate:Date) -> Bool {
    let eventStore = EKEventStore()
    
    let reminder = EKReminder(eventStore: eventStore)
    reminder.title = title
    reminder.calendar = eventStore.defaultCalendarForNewReminders()
    reminder.addAlarm(EKAlarm(absoluteDate: alarmDate))
    do {
        try eventStore.save(reminder, commit: true)
        return true
    }catch let error{
        print(error)
        return false
    }
}

func analyzeDate(date:String,time:String) -> Date? {
    let df = DateFormatter()
    df.locale = Locale.current
    
    var tdate = date
    
    if date.uppercased() == "TODAY" { //Date is Today
        df.dateFormat = "yyyy/MM/dd"
        tdate = df.string(from: Date())
    } else if date.uppercased() == "TOMORROW" { //Date is tomorrow
        df.dateFormat = "yyyy/MM/dd"
        tdate = df.string(from: Date(timeIntervalSinceNow: 60*60*24)) //After 24 hours date
    } else if date == "" { //Not specified
        df.dateFormat = "HH:mm"
        if let tt = df.date(from: time){// MM/DD format (Ex 1/23)
            //Calc only month and date
            let nt = df.date(from: df.string(from: Date()))!

            //Check the time is past or not
            if (tt < nt) {
                //The date is tomorrow
                df.dateFormat = "yyyy/MM/dd"
                tdate = df.string(from: Date(timeIntervalSinceNow: 60*60*24)) //After 24 hours date
            }else{
                //The date is today
                df.dateFormat = "yyyy/MM/dd"
                tdate = df.string(from: Date())
            }
        }
    }else{ //Other format
        df.dateFormat = "MM/dd"
        if let td = df.date(from: date){// MM/DD format (Ex 1/23)
            //Calc only month and date
            let nd = df.date(from: df.string(from: Date()))!
            
            //Calc year
            df.dateFormat = "yyyy"
            let year = Int(df.string(from: Date()))!
            
            //Check the date is past or not
            if (td < nd) {
                //The date is next year
                tdate = "\(year+1)/" + date
            }else{
                //The date is this year
                tdate = "\(year)/" + date
            }
        }
    }
    
    //Convert date
    // Date format (Ex 2000/1/1 12:34)
    df.dateFormat = "yyyy/MM/dd HH:mm"
    return df.date(from: "\(tdate) \(time)")
}

func checkPermission() -> Bool{
    if EKEventStore.authorizationStatus(for: .reminder) == EKAuthorizationStatus.authorized {
        return true
    }
    
    var waitflg = true;
    var grant = false;
    
    if EKEventStore.authorizationStatus(for: .reminder) == EKAuthorizationStatus.notDetermined {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .reminder) { (_grant, _err) in
            grant = _grant
            waitflg = false
        }
        while (waitflg) {sleep(1)}
    }
    
    return grant
}






//Main

//Check arguments count
if CommandLine.argc < 2 || CommandLine.argc > 4 {
    print("Usage: \(CommandLine.arguments[0]) Title (Date) Time")
    print("Example: \(CommandLine.arguments[0]) FooBar 2018/01/01 12:34")
    exit(0)
}

//Check permission
if !checkPermission() {
    print("Not permitted.")
    exit(1)
}


var date:Date = Date()
let title = CommandLine.arguments[1]


if CommandLine.argc == 2 {
    //Title only
    date = Date(timeIntervalSinceNow: 3600)
}else if CommandLine.argc == 3 {
    //Title and time
    if let tdate = analyzeDate(date: "", time: CommandLine.arguments[2]) {
        date = tdate
    }else{
        print("Invalid time(\(CommandLine.arguments[2]))")
    }
}else if CommandLine.argc == 4 {
    //Title, date, and time
    if let tdate = analyzeDate(date: CommandLine.arguments[2], time: CommandLine.arguments[3]) {
        date = tdate
    }else{
        print("Invalid date(\(CommandLine.arguments[2]) \(CommandLine.arguments[3]))")
    }
}

//Add reminder
if addReminder(title: title, alarmDate: date) {
    let df = DateFormatter()
    df.locale = Locale.current
    df.dateFormat = "yyyy/MM/dd HH:mm"
    let sdate = df.string(from: date)
    
    print("\(sdate) : \(title)");
    print("Add reminder");
}else{
    print("Failed to add reminder");
}

