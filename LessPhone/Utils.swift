//
//  UITool.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/7/18.
//

import Foundation

extension Int {
    func hourMinSec() -> (Int, Int, Int) {
        let h = self / 3600
        let m = (self - h * 3600) / 60
        let s = self % 60
        return (h, m, s)
    }
    func hourMin() -> (Int, Int) {
        return (self / 60, self % 60)
    }

    func secToTimeString_ch() -> String {
        let (h, m, s) = self.hourMinSec()
        var res = ""
        if h != 0 {
            res += "\(h)小时"
        }
        if m != 0 {
            res += "\(m)分钟"
        }
        if (h == 0 && m == 0) {
            res = "\(s)秒"
        }
        return res
    }
    func minToTimeString_ch() -> String {
        let (h, m) = self.hourMin()
        var res = ""
        if h != 0 {
            res += "\(h)小时"
        }
        if m != 0 {
            res += "\(m)分钟"
        }
        return res
    }
    func timeString() -> String {
        let (h, m, s) = self.hourMinSec()
        return "\(h):\(m):\(s)"
    }
    func timeString_hm() -> String {
        let (h, m, _) = self.hourMinSec()
        return "\(h):\(m)"
    }
   
}

extension Date {
    
    func timeString() -> String {
        return beijingStr("HH:mm:ss")
    }
    func timeString_hm() -> String {
        return beijingStr("HH:mm")
    }
    // 返回北京时间
    static func current() -> Date {
        let date = Date()
        let interval = NSTimeZone.system.secondsFromGMT(for: date)
        return date.addingTimeInterval(TimeInterval(interval))
    }
    // 返回北京时间
    func beijing() -> Date {
        let interval = NSTimeZone.system.secondsFromGMT(for: self)
        return self.addingTimeInterval(TimeInterval(interval))
    }
    private static let formatter =  DateFormatter()
    
    func beijingStr(_ formatterStr: String) -> String {
        Date.formatter.dateFormat = formatterStr
        Date.formatter.timeZone = TimeZone.current
        return Date.formatter.string(from: self)
    }
}
