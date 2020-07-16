//
//  ContentView.swift
//  SwiftQRCodeScan
//
//  Created by 李毅 on 2020/7/1.
//

import SwiftUI
import Then

struct ContentView: View {
    var body: some View {

        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .circular)
            Text("Hello, world!").padding().foregroundColor(.gray)
        }.foregroundColor(.orange)
    }
    
    
    func sayHello() {
        let _ = String().then {
            $0.appending("aaa")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
