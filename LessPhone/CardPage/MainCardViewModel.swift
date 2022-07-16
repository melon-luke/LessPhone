//
//  MainCardViewModel.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/7/15.
//

import Foundation
import Combine

class MainCardViewModel: ObservableObject {
    @Published var model = Statistics.shared
    
    var screenTime: String {
        let (h, m, s) = model.hourMinSec(from: model.screenTime)
        return "\(h):\(m):\(s)"
    }
    
//    @Published var isWalking: Bool
//    @Binding var stepCount: Int
}

//class MainCardViewModel {
//
//}
