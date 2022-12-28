//
//  Date+Extensionn.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 09/03/2022.
//

import Foundation

public extension Formatter {
    
    enum DateFormat: String {
        
        case option1 = "dd MM yyyy"
        case option2 = "dd/MM/yyyy"
        case option3 = "dd MMM yyyy"
        case option4 = "dd-MMM-yyyy"
        case option5 = "dd-MMM-yyyy HH:mm:ss"
        case option6 = "dd/MM/yyyy hh:mm a"
        case option7 = "dd-MM-yyyy"
        case option8 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case option9 = "E, d MMMM"
        case option10 = "dd-MMM-yyyy HH:mm:ss a"
        case option11 = "yyyyMMdd"
        case option12 = "E, d MMM yyyy"
        case option13 = "dd MMMM yyyy, HH:mm:ss a"
        case option14 = "yyyy-MM-dd'T'HH:mm:ss'"
        case option15 = "dd MMMM"
        case option16 = "yyyy/MM/dd"
        
        case timeOption1 = "HH:mm:ss"
        case timeOption2 = "h:mm a"
    }
    
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.ReferenceType.local
        formatter.dateFormat = "dd-MMM-yyyy h:mm:ss a"
        return formatter
    }()
    
}

// MARK: - Date Extensions
public extension Date {
    
    var yesterday: Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
    var nextDay: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    
    var lastWeek: Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)
    }
    
    var nextWeek: Date? {
        return Calendar.current.date(byAdding: .day, value: 7, to: self)
    }
    
    
    var last2Week: Date? {
        return Calendar.current.date(byAdding: .day, value: -(7*2), to: self)
    }
    
    var next2Week: Date? {
        return Calendar.current.date(byAdding: .day, value: (7*2), to: self)
    }
    
    var nextMonth: Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }
    
    var previousMonth: Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    var next3Month: Date? {
        return Calendar.current.date(byAdding: .month, value: 3, to: self)
    }
    
    var previous3Month: Date? {
        return Calendar.current.date(byAdding: .month, value: -3, to: self)
    }
    
    var next6Month: Date? {
        return Calendar.current.date(byAdding: .month, value: 6, to: self)
    }
    
    var previous6Month: Date? {
        return Calendar.current.date(byAdding: .month, value: -6, to: self)
    }
    
    var nextYear: Date? {
        return Calendar.current.date(byAdding: .year, value: 1, to: self)
    }
    
    var previousYear: Date? {
        return Calendar.current.date(byAdding: .year, value: -1, to: self)
    }
    
//    func previousMonth() -> Date? {
//        return Calendar.current.date(byAdding: .month, value: -1, to: self)
//    }
    
    var last7Days: Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)
    }
    
    var last30Days: Date? {
        return Calendar.current.date(byAdding: .day, value: -30, to: self)
    }
    
    var last60Days: Date? {
        return Calendar.current.date(byAdding: .day, value: -60, to: self)
    }
    
    var next60Days: Date? {
        return Calendar.current.date(byAdding: .day, value: 60, to: self)
    }
    
    var iso8601ToString: String {
        return Formatter.iso8601.string(from: self)
    }
    
    func toIso8601String(with dateFormat: Formatter.DateFormat = .option1) -> String {
        let formatter = Formatter.iso8601
        formatter.dateFormat = dateFormat.rawValue
        let str = formatter.string(from: self)
        return str
    }
    
    func toString(with dateFormat: Formatter.DateFormat = .option1) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
        let str = formatter.string(from: self)
        return str
    }
    
}

public extension String {
    
    var iso8601ToDate: Date? {
        return Formatter.iso8601.date(from: self)
    }
    
    func toDate(with dateFormat: Formatter.DateFormat = .option1) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
        let date = formatter.date(from: self)
        return date
    }
    
    func isoDate(with dateFormat: Formatter.DateFormat = .option1) -> Date? {
        let formatter = Formatter.iso8601
        formatter.dateFormat = dateFormat.rawValue
        let date = formatter.date(from: self)
        return date
    }
}


// MARK: - Date Extensions
// Repeat
public extension Date {
    func getNextDay(repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: (1 * time), to: self)
    }

    func getNextWeek(repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: (7 * time), to: self)
    }
    
    func getNext2Week(repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: ((7 * 2) * time), to: self)
    }
    
    func getNextMonth(repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: (1 * time), to: self)
    }
    
    func getNext3Month(repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: (3 * time), to: self)
    }
    
    func getNext6Month(repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: (6 * time), to: self)
    }
    
    func getNextYear(repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .year, value: (1 * time), to: self)
    }
    
    // with starting date
    
    func getNextDay(start date: Date, repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: (1 * time), to: date)
    }

    func getNextWeek(start date: Date, repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: (7 * time), to: date)
    }
    
    func getNext2Week(start date: Date, repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: ((7 * 2) * time), to: date)
    }
    
    func getNextMonth(start date: Date, repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: (1 * time), to: date)
    }
    
    func getNext3Month(start date: Date, repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: (3 * time), to: date)
    }
    
    func getNext6Month(start date: Date, repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: (6 * time), to: date)
    }
    
    func getNextYear(start date: Date, repeat time: Int) -> Date? {
        return Calendar.current.date(byAdding: .year, value: (1 * time), to: date)
    }
    
}

