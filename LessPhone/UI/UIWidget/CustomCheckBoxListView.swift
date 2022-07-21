//
//  checkBoxView.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/7/19.
//

import SwiftUI

struct CustomCheckBoxListView: View {
    var title: String
    var list: [String]
    @State var selectedIndex: Int = 0
    var didSelect: ((Int) -> ())
    var body: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .opacity(0.2)
                .onTapGesture {
                    didSelect(selectedIndex)
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
            VStack(alignment: .leading, spacing: 36) {
                Text(title)
                    .font(Font.system(.title2))
                    .foregroundColor(Color.text_main)
                    .frame(alignment: .topLeading)
                VStack(alignment: .trailing, spacing: 36) {
                    ForEach(list.indices, id: \.self) { i in
                        HStack {
                            Text(list[i])
                            Spacer()
                            Image(selectedIndex == i ? "checkbox_seleted" : "checkbox")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { 
                            selectedIndex = i
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                didSelect(selectedIndex)
                            }
                        }
                        
                    }
                }
                
            }
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

struct checkBoxView_Previews: PreviewProvider {
    static var previews: some View {
        let data = ["15分钟", "30分钟", "1小时"]
        CustomCheckBoxListView(title: "每使用屏幕",
                     list: data) { index in
            print(data[index])
        }
        .previewInterfaceOrientation(.portrait)
    }
}
