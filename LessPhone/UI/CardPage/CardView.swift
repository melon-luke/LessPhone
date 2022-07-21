//
//  CardView.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/7/18.
//

import SwiftUI

struct CardView: View {
    var title: String
    var image: Image
    var subTitle: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).fill(Color.white) .shadow(color: Color.black.opacity(0.1), radius: 10, y:7)
            VStack {
                Spacer()
                Text(title)
                Spacer()
                    .fixedSize()
                    .frame(height: 5)
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .padding()
//                    .aspectRatio(0.9, contentMode: .fit)
                Spacer()
                    .fixedSize()
                    .frame(height: 5)
                Text(subTitle)
                Spacer()
            }
        }
       
        .aspectRatio(0.9, contentMode: .fit)
        .padding(9)
//        .frame(width: 120, height: 180, alignment: .center)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(title: "拿起次数",
                 image: Image("pickup_count"),
                 subTitle: "40次")
        
    }
}
