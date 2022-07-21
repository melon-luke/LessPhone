//
//  SwiftUIPickerView.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/7/20.
//

import SwiftUI

struct SwiftUIPickerView: View {
    let data: (hour: [Int], minute: [Int])
    @State var selectedHIndex: Int = 0
    @State var selectedMIndex: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Picker("Favorite Color", selection: $selectedHIndex) {
                        ForEach(data.hour.indices, id: \.self) { i in
                            Text("\(data.hour[i])")
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.wheel)
                    .fixedSize(horizontal: true, vertical: true)
                    .frame(width: geometry.size.width/2, alignment: .center)
                    .compositingGroup()
//                    .clipped()
                    
                    Picker("Favorite Color", selection: $selectedMIndex) {
                        ForEach(data.hour.indices, id: \.self) { i in
                            Text("\(data.minute[i])")
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.wheel)
                    .fixedSize(horizontal: true, vertical: true)
                    .frame(width: geometry.size.width/2, alignment: .center)
                    //                            .compositingGroup()
//                    .clipped()
                }
                Text("\(selectedHIndex)     \(selectedMIndex)")
            }.mask(Rectangle())
        }
    }
}

struct SwiftUIPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let data = Preference.Const.beginOfDaytPicker
        let a = (hour:[0, 1, 2, 3, 4],
                 minute: [0,10,20,30,40,50,60])
        SwiftUIPickerView(data: a)
    }
}
