//
//  PreferenceView.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/7/15.
//

import SwiftUI

struct PreferenceView: View {
    @State private var allowNotifUser = true
    @State private var showPickupTimesView = false
    @State private var showPerScreenTimeView = false
    @State private var showTodayBeginPickerView = false
    @State private var showScreenLimitPickerView = false
    
    var footer: some View {
        Text("This is a disclaimer about section number 2. Use at your own risk.")
    }
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .fixedSize()
                    .frame(height: 28)
                List {
                    Section() {
                        HStack {
                            Text("每日开始于")
                            Spacer()
                            Text(Statistics.shared.todayBeginDate().timeString_hm())
                                .foregroundColor(Color.text_sub)
                            Image(systemName: "chevron.forward")
                                .foregroundColor(Color.text_sub)
                        }.onTapGesture {
                            showTodayBeginPickerView.toggle()
                        }
                    }
                    Section() {
                        HStack {
                            Text("屏幕使用时间限制")
                            Spacer()
                            Text(Preference.screenLimitTime.minToTimeString_ch())
                                .foregroundColor(Color.text_sub)
                            Image(systemName: "chevron.forward")
                                .foregroundColor(Color.text_sub)
                        }.onTapGesture {
                            showScreenLimitPickerView.toggle()
                        }
                    }
                    Section(header: Text("Section #2"), footer: footer) {
                        HStack {
                            Text("允许通知")
                            Spacer()
                            Toggle("", isOn: $allowNotifUser)
                                .tint(.stress)
                        }
                        
                    }
                    if allowNotifUser {
                        Section(header: Text("提醒方式"), footer: footer) {
                            HStack {
                                Text("每使用屏幕")
                                Spacer()
                                Text("\(Preference.screenLimitTimeRemindPerMinute)分钟")
                                    .foregroundColor(Color.text_sub)
                                Image(systemName: "chevron.forward")
                                    .foregroundColor(Color.text_sub)
                            }.onTapGesture {
                                showPerScreenTimeView.toggle()
                            }
                            HStack {
                                Text("每拿起次数")
                                Spacer()
                                Text("\(Preference.pickupRemindPerCount)次")
                                    .foregroundColor(Color.text_sub)
                                Image(systemName: "chevron.forward")
                                    .foregroundColor(Color.text_sub)
                            }.onTapGesture {
                                showPickupTimesView.toggle()
                            }
                        }
                    }
                }
                

            }
           
            .background {
                Color.background
            }
            .onAppear() {
                UITableViewCell.appearance().backgroundColor = UIColor.white
                UITableView.appearance().backgroundColor = UIColor.clear
            }

            if showPickupTimesView {
                let count = Preference.pickupRemindPerCount
                let data = Preference.Const.pickupCount
                let selectedIndex = data.firstIndex(of: count) ?? 0
                let showedList = data.map { "\($0)次" }
                CustomCheckBoxListView(title: "每拿起次数",
                                       list: showedList,
                                       selectedIndex: selectedIndex) { index in
                    Preference.pickupRemindPerCount = data[index]
                    showPickupTimesView = false
                }
            }
            if showPerScreenTimeView {
                let min = Preference.screenLimitTimeRemindPerMinute
                let data = Preference.Const.remindPerMinuteArr
                let selectedIndex = data.firstIndex(of: min) ?? 0
                let showedList = data.map { "\($0)分钟" }
                CustomCheckBoxListView(title: "每使用屏幕",
                                       list: showedList,
                                       selectedIndex: selectedIndex) { index in
                    Preference.screenLimitTimeRemindPerMinute = data[index]
                    showPerScreenTimeView = false
                }
            }
            if showTodayBeginPickerView {
//                let a = Preference.Const.beginOfDaytPicker
//                let data: [[String]] = [
//                    a.hour.map { "\($0)" },
//                    a.minute.map { "\($0)" },
//                ]
//                let selectios = [0, 5]
                
                let pickerData = Preference.Const.beginOfDaytPicker
                let data = Statistics.hourMinStrArray(from: pickerData)
                
                let beginOfDay = Preference.beginOfDay
                let selection = Statistics.hourMinIndexArray(from: beginOfDay, in: pickerData)
                CustomPickerView(title:  "每日开始于",
                                 data: data,
                                 selections: selection ?? [0, 0],
                                 style: .en) { newSelection in
                    Preference.beginOfDay = Statistics.totalMin(of: newSelection, in: pickerData) ?? 5
                    showTodayBeginPickerView = false
                }
            }
            if showScreenLimitPickerView {
                let pickerData = Preference.Const.screenLimitPicker
                let data = Statistics.hourMinStrArray(from: pickerData)
                
                let limitTime = Preference.screenLimitTime
                let selection = Statistics.hourMinIndexArray(from: limitTime, in: pickerData)
              
                CustomPickerView(title:  "选择限额",
                                 data: data,
                                 selections: selection ?? [5, 0],
                                 style: .ch) { newSelection in
                   
                    Preference.screenLimitTime = Statistics.totalMin(of: newSelection, in: pickerData) ?? 5
                    showScreenLimitPickerView = false
                }
            }
        }.ignoresSafeArea()
        .background {
            Color.background
        }
        
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
    }
}
