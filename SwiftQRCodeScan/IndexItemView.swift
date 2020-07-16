//
//  IndexItemView.swift
//  SwiftQRCodeScan
//
//  Created by 李毅 on 2020/7/10.
//

import SwiftUI

struct IndexItemView: View {
    var body: some View {
        HStack {
            Text(indexItemModel.icon).font(Iconfont.fontOfSize(20, fontInfo: Iconfont.solidFont))
            Text(indexItemModel.name)
        }.frame(height: 44)
    }

    var indexItemModel: IndexItemModel
}

struct IndexItemView_Previews: PreviewProvider {
    static var previews: some View {
        IndexItemView(indexItemModel:
            IndexItemModel(name: "hello", icon: "\u{f065}") {
                AnyView(Text("s"))
        })
    }
}

struct IndexItemModel: Identifiable {
    var id = UUID()
    var name: String
    var icon: String
    var initBlock: () -> AnyView
}
