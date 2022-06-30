//
//  Preference.swift
//  LessPhone
//  规则、设置
//  Created by 宋申易 on 2022/6/29.
//

import Foundation

struct Preference {
    // h: m = beginOfDay / 60 : beginOfDay % 60
    // 存总分钟数
    static var beginOfDay: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "kUserbeginOfDay")
        }
        get {
            UserDefaults.standard.integer(forKey: "kUserbeginOfDay")
        }
    }
}
