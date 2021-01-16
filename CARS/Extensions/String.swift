//
//  String.swift
//  CARS
//
//  Created by DEEPALI MAHESHWARI on 31/12/20.
//  Copyright © 2020 DEEPALI MAHESHWARI. All rights reserved.
//

import Foundation

extension String {
    
    func getFormattedDateString(format : String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm"

        let dateFormatterPrint = DateFormatter()
        
        let dateTimeArr = self.split(separator: " ")
        let dateString = String(dateTimeArr[0])

        let dateComponents = dateString.split(separator: ".")
        let year = Int(dateComponents[2])

        setDateFormat(format: format, year: year, dateFormatterPrint: dateFormatterPrint)
        let date: Date? = dateFormatterGet.date(from: self)
        let dateStr = dateFormatterPrint.string(from: date!)
        return dateStr
    }
    
    private func setDateFormat(format : String, year : Int?, dateFormatterPrint : DateFormatter) {
        let currentYear = Calendar.current.component(.year, from: Date())
        if format == "24"
        {
            if let year = year, year < currentYear {
                dateFormatterPrint.dateFormat = "dd MMMM yyyy, HH:mm"
            } else {
                dateFormatterPrint.dateFormat = "dd MMMM, HH:mm"
            }
            
        } else {
            if let year = year, year < currentYear {
                dateFormatterPrint.dateFormat = "dd MMMM yyyy, h:mm a"
            } else {
                dateFormatterPrint.dateFormat = "dd MMMM, h:mm a"
            }
        }
        
    }
}
