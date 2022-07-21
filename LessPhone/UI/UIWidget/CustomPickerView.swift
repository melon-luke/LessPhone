//
//  CustomPickerView.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/7/18.
//

import SwiftUI

struct CustomPickerView: View {
    enum Style {
        case en
        case ch
    }
    
    let title: String
    var data: [[String]]
    @State var selections: [Int]
    let style: Style
    let didSelect: ([Int]) -> ()
    @State private var selected = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .opacity(0.2)
                .onTapGesture {
                    didSelect(selections)
                }
            VStack {
                Spacer()
                createPanel()
            }
        }.ignoresSafeArea()
    }
    func createPanel() -> some View {
        let space: CGFloat = 18
        return ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
            //            GeometryReader { geometry in
            VStack(alignment: .leading) {
                Spacer()
                    .fixedSize()
                    .frame(height: 18)
                Text(title)
                    .font(Font.system(.title2))
                    .foregroundColor(Color.text_main)
                    .frame(alignment: .topLeading)
                
                ZStack {
                    PickerView(data: self.data, selections: self.$selections)
                    if style == .ch {
                        HStack {
                            Spacer()
                                .fixedSize()
                                .frame(width: 100)
                            Text("小时")
                            Spacer()
                            Text("分钟")
                            Spacer()
                                .fixedSize()
                                .frame(width: 20)
                        }
                    } else {
                        Text(":").font(.system(size: 25))
                    }
                   
                }
                HStack {
                    Spacer()
                    Button {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            didSelect(selections)
                        }
                    } label: {
                        Image("ok_btn").resizable()
//                        Image(selected ? "ok_selected_btn" : "ok_btn").resizable()
                    }
                    .frame(width: 60, height: 60)
                }
            }
            
            //            }
            .padding(EdgeInsets(top: 0,
                                leading: space,
                                bottom: space,
                                trailing: space))
        }
        .frame(height: 280, alignment: .bottom)
        .padding(EdgeInsets(top: 0, leading: space, bottom: space * 5, trailing: space))
        .safeAreaInset(edge: .bottom) {
            Text("")
        }
    }
}

struct CustomPickerView_Previews: PreviewProvider {
    static var previews: some View {
                let a = Preference.Const.beginOfDaytPicker
//        let a = (hour:[0, 1, 2, 3, 4],
//                 minute: [0,10,20,30,40,50,60])
        let data: [[String]] = [
            a.hour.map { "\($0)" },
            a.minute.map { "\($0)" },
        ]
        let selectios = [0, 5]
        CustomPickerView(title:  "每日开始于",
                         data: data,
                         selections: selectios,
                         style: .ch) { selections in
            
        }
    }
}
