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
                Text("Hello, world!")
                    .padding()
//        Button("转横屏") {
//            if #available(iOS 16.0, *) {
//                sceneDelegate.window?.windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeLeft))
//            } else {
//
//                UIDevice.current.setValue(UIDeviceOrientation.landscapeLeft.rawValue, forKey: "orientation")
//            }
//        }
//        Button("转竖屏") {
//            if #available(iOS 16.0, *) {
//                sceneDelegate.window?.windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
//            } else {
//                UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
//            }
//
//
//        }
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
