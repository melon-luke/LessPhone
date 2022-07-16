//
//  ContentView.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/6/3.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sceneDelegate: SceneDelegate

    var body: some View {
        TabView {
            MainCardView()
                .tabItem {
                    Image(systemName: "iphone.homebutton")
                }
            
            PreferenceView()
                .tabItem {
                    Image(systemName: "gearshape")
                }
        }
       
//        ScrollViewReader { proxy in
//            ScrollView {
//                Text("Hello, world!")
////                Button("fetch CoreData") {
////                    Storage.shared.fetch()
////                }
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
