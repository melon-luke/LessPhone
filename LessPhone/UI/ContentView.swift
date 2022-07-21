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
            .background {
                Color.background
            }
            .tabItem {
                Image(systemName: "iphone.homebutton")
            }
 
                PreferenceView()
            .tabItem {
                Image(systemName: "gearshape")
            }
        }
        .tabViewStyle(.automatic)
        .accentColor(.stress)
//        .edgesIgnoringSafeArea(.top)
    }
    init() {
        UITabBar.appearance().isOpaque = false
//        UITabBar.appearance().backgroundColor = UIColor(named: "background")
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "background")
        
//        appearance. = UIColor(named: "background")

//        appearance. = false
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
