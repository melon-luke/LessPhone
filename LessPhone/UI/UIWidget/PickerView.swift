//
//  PickerView.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/7/20.
//

import Foundation
import SwiftUI

struct PickerView: UIViewRepresentable {
    var data: [[String]]
    @Binding var selections: [Int]
    
    //makeCoordinator()
    func makeCoordinator() -> PickerView.Coordinator {
        Coordinator(self)
    }
    
    //makeUIView(context:)
    func makeUIView(context: UIViewRepresentableContext<PickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        return picker
    }
    
    //updateUIView(_:context:)
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<PickerView>) {
        for i in 0...(self.selections.count - 1) {
            view.selectRow(self.selections[i], inComponent: i, animated: false)
        }
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: PickerView
        
        //init(_:)
        init(_ pickerView: PickerView) {
            self.parent = pickerView
        }
        
        //numberOfComponents(in:)
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return self.parent.data.count
        }
        
        //pickerView(_:numberOfRowsInComponent:)
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.data[component].count
        }
        
        //pickerView(_:titleForRow:forComponent:)
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.parent.data[component][row]
        }
        
        //pickerView(_:didSelectRow:inComponent:)
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selections[component] = row
        }
    }
}

import SwiftUI

struct PPView: View {
    private let data: [[String]] = [
        Array(0...10).map { "\($0)" },
        Array(20...40).map { "\($0)" },
        //        Array(100...200).map { "\($0)" }
    ]
    
    @State private var selections: [Int] = [5, 10]
    
    var body: some View {
        VStack {
            ZStack {
                PickerView(data: self.data, selections: self.$selections)
                Text(":").font(.system(size: 16))
//                HStack {
//                    Spacer()
//                        .fixedSize()
//                        .frame(width: 130)
//                    Text("小时")
//                    Spacer()
//                    Text("分钟")
//                    Spacer()
//                        .fixedSize()
//                        .frame(width: 50)
//                }
            }
            Text("\(self.data[0][self.selections[0]]) \(self.data[1][self.selections[1]])")
        } //VStack
    }
}

struct PPView_Previews: PreviewProvider {
    static var previews: some View {
        PPView()
    }
}

//struct PickerView_Previews: PreviewProvider {
//    let data: [[String]] = [
//        Array(0...10).map { "\($0)" },
//        Array(20...40).map { "\($0)" },
//        Array(100...200).map { "\($0)" }
//    ]
//    @State private var selections: [Int] = [5, 10, 50]
//
//    static var previews: some View {
//
//        PickerView(data: data, selections: self.$selections)
//    }
//}
