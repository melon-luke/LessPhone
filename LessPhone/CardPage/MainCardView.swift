//
//  MainCardView.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/7/15.
//

import SwiftUI

struct MainCardView: View {
    @ObservedObject var model = Statistics.shared
    
    
    var body: some View {
        VStack {
            Text("今天开始时间: \(model.todayBeginDate())")
          
            Text("屏幕时间(秒):\(timeString(model.screenTime))")
            Text("边走边看屏幕时间(秒):\(timeString(model.screenTimeInWalking))")
            Text("呆呆地看(秒):\(timeString(model.screenTimeInStill))")
            Text("第一次拿起:\(timeString(model.firstTimePickup))")
            Text("昨天最后一次放下:\(timeString(model.lastTimePutDownYesterday))")
            Text("今天最后一次放下:\(timeString(model.lastTimePutDownYesterday))")
//            Text("step count:\(viewmodel.stepCount)")
//            Text("iswalking:\(viewmodel.isWalking)")
        }
    }
    func timeString(_ second: Int) -> String {
        let (h, m, s) = model.hourMinSec(from: model.screenTimeInStill)
        return "\(h):\(m):\(s)"
    }
    func timeString(_ date: Date?) -> String {
        guard let date = date else { return "" }
            
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}

struct MainCardView_Previews: PreviewProvider {
    static var previews: some View {
        MainCardView()
    }
}
