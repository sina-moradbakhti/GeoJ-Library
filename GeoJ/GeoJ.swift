//
//  GeoJ.swift
//  melkava
//
//  Created by Sina Moradbakhti on 8/1/18.
//  Copyright © 2018 parcweb. All rights reserved.
//

import UIKit

enum GeoJLabels:String
{
    case Ymd = "ymd"
    case mdY = "mdy"
    case dmY = "dmy"
}
enum GeoJDelimiters:Character
{
    case dash = "-"
    case slash = "/"
}
class GeoJMonthDayObj
{
    var day:Int = 0
    var month:Int = 0
    init(day:Int,month:Int) {
        self.day = day
        self.month = month
    }
}
class GeoJ
{
    private var jalaliYear:Int = 0
    private var jalaliMonth:Int = 0
    private var jalaliDay:Int = 0
    
    private var jalaliKabiseCount:Int = 0
    private var geoKabiseCount:Int = 0
    private var isKabiseGeo:Bool = false
    private var diffrenceOfGeoAndJ:Int = 226899
    
    init(yearNumber:Int,monthNumber:Int,dayNumber:Int)
    {
        let year = yearNumber
        let month = monthNumber
        let day = dayNumber
        self.changeDate(year: year, month: month, day: day)
    }
    init(date:String,delimiter:GeoJDelimiters = GeoJDelimiters.dash,label:GeoJLabels = GeoJLabels.mdY)
    {
        var year = 0
        var month = 0
        var day = 0
        let newDateEX = date.split(separator: delimiter.rawValue).map(String.init)
        if(label == .dmY)
        {
            year = Int(newDateEX[2])!
            month = Int(newDateEX[1])!
            day = Int(newDateEX[0])!
        }
        else if(label == .mdY)
        {
            year = Int(newDateEX[2])!
            month = Int(newDateEX[0])!
            day = Int(newDateEX[1])!
        }
        else if(label == .Ymd)
        {
            year = Int(newDateEX[0])!
            month = Int(newDateEX[1])!
            day = Int(newDateEX[2])!
        }
        self.changeDate(year: year, month: month, day: day)
    }
    
    private func getJalaliYear(geoYear:Int) -> Int
    {
        let formatter1 = DateFormatter()
        let date1 = Date()
        formatter1.calendar = Calendar(identifier: .gregorian)
        formatter1.dateFormat = "yyyy"
        let gyear = Int(formatter1.string(from: date1))!
        let diff:Int = gyear - geoYear
        let formatter = DateFormatter()
        let date = Date()
        formatter.calendar = Calendar(identifier: .persian)
        formatter.dateFormat = "yyyy"
        let jyear = Int(formatter.string(from: date))!
        return jyear - diff
    }
    private func getGeoMonthDays(month:Int) -> Int
    {
        if(self.isKabiseGeo)
        {
            switch month
            {
            case 1:
                return 31
            case 2:
                return 31 + 29
            case 3:
                return 31 + 29 + 31
            case 4:
                return 31 + 29 + 31 + 30
            case 5:
                return 31 + 29 + 31 + 30 + 31
            case 6:
                return 31 + 29 + 31 + 30 + 31 + 30
            case 7:
                return 31 + 29 + 31 + 30 + 31 + 30 + 31
            case 8:
                return 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31
            case 9:
                return 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31 + 30
            case 10:
                return 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31
            case 11:
                return 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30
            case 12:
                return 31 + 29 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30 + 31
            default:
                return 0
            }
        }
        else
        {
            switch month
            {
            case 1:
                return 31
            case 2:
                return 31 + 28
            case 3:
                return 31 + 28 + 31
            case 4:
                return 31 + 28 + 31 + 30
            case 5:
                return 31 + 28 + 31 + 30 + 31
            case 6:
                return 31 + 28 + 31 + 30 + 31 + 30
            case 7:
                return 31 + 28 + 31 + 30 + 31 + 30 + 31
            case 8:
                return 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31
            case 9:
                return 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30
            case 10:
                return 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31
            case 11:
                return 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30
            case 12:
                return 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30 + 31
            default:
                return 0
            }
        }
    }
        
    private func isKabise(year:Int,isGeo:Bool = true)
    {
        if(isGeo)
        {
            if(year % 4 == 0 && year % 400 == 0 && year % 100 == 0)
            {
                self.isKabiseGeo = true
            }
            else
            {
                self.isKabiseGeo = false
            }
        }
    }
    private func geoKabiseCountCalculator(year:Int)
    {
        let kabiseCount:Int = Int((year - 1) / 4)
        self.geoKabiseCount = kabiseCount
    }
    private func jalaliKabiseCountCalculator(year:Int)
    {
        
        let kabiseCount:Int = Int((year - 1) / 4)
        self.jalaliKabiseCount = kabiseCount
    }
    private func getGeoMonthAndDay(mode:Int) -> GeoJMonthDayObj
    {
        var returnObj:GeoJMonthDayObj = GeoJMonthDayObj(day: 0, month: 0)
        var number:Int = 0
        number = mode
        for i in 1...12
        {
            if(i < 7)
            {
                if(number < 31)
                {
                    returnObj = GeoJMonthDayObj(day: number, month: i)
                    return returnObj
                }
                number = number - 31
            }
            else
            {
                if(number < 30)
                {
                    returnObj = GeoJMonthDayObj(day: number, month: i)
                    return returnObj
                }
                number = number - 30
            }
        }
        return returnObj
    }
    private func changeDate(year:Int,month:Int,day:Int)
    {
        var totalDays:Int = 0
        self.isKabise(year: year)
        self.geoKabiseCountCalculator(year: year)
        totalDays = ((year - 1) * 365)
        totalDays += self.geoKabiseCount
        totalDays += self.getGeoMonthDays(month: month - 1)
        totalDays += day
        totalDays -= self.diffrenceOfGeoAndJ
        self.jalaliKabiseCountCalculator(year: (self.getJalaliYear(geoYear:year)))
        totalDays = totalDays - self.jalaliKabiseCount
        
        let jalaliYear:Int = Int(totalDays / 365)
        let obj:GeoJMonthDayObj = self.getGeoMonthAndDay(mode: Int(totalDays % 365))
        let jalaliMonth:Int = obj.month
        let jalaliDay:Int = obj.day
        
        self.jalaliYear = jalaliYear + 1
        self.jalaliMonth = jalaliMonth
        self.jalaliDay = jalaliDay
    }
    func getJalaliDate() -> [Int]
    {
        return [self.jalaliYear,self.jalaliMonth,self.jalaliDay]
    }
}
