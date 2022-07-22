//
//  CircularProgressView.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/7/18.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: CGFloat
    var body: some View {
        ZStack { // 1
            Circle()
                .stroke(
                    Color.progress_bg,
                    lineWidth: 20
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.stress,
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round)
                )
            // 默认从右边往下开始，需要逆时针转90度
                .rotationEffect(.degrees(-90))
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.5)
    }
}
