//
//  DebugTool.swift
//  LessPhone
//
//  Created by 宋申易 on 2022/6/4.
//

import Foundation

//let baseUrl = "http://192.168.31.158:8000/"
let baseUrl = "http://10.237.93.3:8000/"

func rp(_ log: String) {
    print("🌻LOG \(Date()): " + log)
    return
    let url = "\(baseUrl)?log=\(log.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
    URLSession.shared.dataTask(with: URL(string: url)!) { data, reponse, err in
        if err != nil {
            print("remote log failed")
        }
    }.resume()
}


