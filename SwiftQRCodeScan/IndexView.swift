//
//  IndexView.swift
//  SwiftQRCodeScan
//
//  Created by 李毅 on 2020/7/10.
//

import SwiftUI

struct IndexView: View {
    var body: some View {
        return List(indexItemModels) { model in
            NavigationLink(destination: model.initBlock()) {
                IndexItemView(indexItemModel: model)
            }
        }.navigationBarTitle(title, displayMode: .large)
    }

    var title: String {
        guard let dict = Bundle.main.infoDictionary, let title = dict["CFBundleDisplayName"] as? String else {
            fatalError()
        }
        return title
    }

    var indexItemModels = [
        IndexItemModel(name: "扫描", icon: "\u{f065}") { AnyView(ScanView()) },
        IndexItemModel(name: "扫描记录", icon: "\u{f1da}") { AnyView(HistoryView()) },
        IndexItemModel(name: "生成", icon: "\u{f029}") { AnyView(GenerateView()) },
        IndexItemModel(name: "设置", icon: "\u{f013}") { AnyView(SettingView()) }]
}

struct IndexView_Previews: PreviewProvider {
    static var previews: some View {
        IndexView()
    }
}
