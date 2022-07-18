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
        ScrollView {
            VStack {
                todayTimeScreenView
                debugView
            }
        }.background(Color.background)
    }
    
}
extension MainCardView {
    var todayTimeScreenView: some View {
        ZStack {
            let progress: CGFloat = CGFloat(model.screenTime) / 500.0
            CircularProgressView(progress: progress)
                        .frame(width: 200, height: 200)
            
            VStack {
                Text("\(timeString(model.screenTime))")
                    .foregroundColor(Color.text_main)
                    .font(Font.system(.largeTitle))
                Text("今日屏幕使用时间")
                    .font(Font.system(.footnote))
                    .foregroundColor(Color.text_sub)
            }
        }
    }
    var debugView: some View {
        VStack {
            HStack {
                Button("fetch CoreData") {
                    Storage.shared.fetch()
                }
                Spacer()
                Button("clean CoreData") {
                    Storage.shared.delete()
                }
            }
           
        Text("今天开始时间: \(model.todayBeginDate())")
            Text("今天开始时间str: \(timeString(model.todayBeginDate()))")
          
            Text("屏幕时间(秒):\(timeString(model.screenTime))")
            Text("边走边看屏幕时间(秒):\(timeString(model.screenTimeInWalking))")
            Text("呆呆地看(秒):\(timeString(model.screenTimeInStill))")
            Text("今天拿起次数:\(model.pickupCount)")
            if let date = model.firstTimePickup{
                Text("第一次拿起\(date))")
                Text("第一次拿起str\(timeString(date))")
            }
            Text("昨天最后一次放下:\(timeString(model.lastTimePutDownYesterday))")
            Text("今天最后一次放下:\(timeString(model.lastTimePutDownToday))")
        }
    }
    func timeString(_ second: Int) -> String {
        let (h, m, s) = model.hourMinSec(from: second)
        return "\(h):\(m):\(s)"
    }
    func timeString(_ date: Date?) -> String {
        guard let date = date else { return "" }
        return date.beijingStr("yyyy年MM月dd日 HH:mm:ss")
    }
}


struct MainCardView_Previews: PreviewProvider {
    static var previews: some View {
        MainCardView()
    }
}
