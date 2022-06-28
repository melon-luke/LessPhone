//
//  ContentView.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/6/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        Text("Hello, world!")
//            .padding()
        ScrollViewReader { proxy in
            ScrollView {
                Text("Hello, world!")
                Button("fetch CoreData") {
                    Storage.shared.fetch()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
