//
//  SettingView.swift
//  SwiftQRCodeScan
//
//  Created by 李毅 on 2020/7/10.
//

import SwiftUI

struct SettingView: View {
    @State var showShared = false
//    @State var shock = Setting.shared.shock {
//        willSet {
//            Setting.shared.shock = newValue
//        }
//    }
    @ObservedObject var settingObservable = SettingObservable()

    var body: some View {
        List {
            Section(header: Text("")) {
                HStack {
                    Text("\u{f09b}")
                        .font(Iconfont.fontOfSize(iconWidth, fontInfo: Iconfont.brandsFont))
                        .frame(width: iconWidth)
                    Text("源代码")
                }.frame(height: iconWidth).onTapGesture {
                    if UIApplication.shared.canOpenURL(githubURL) {
                        UIApplication.shared.open(githubURL)
                    }
                }
                HStack {
                    Text("\u{f370}")
                        .font(Iconfont.fontOfSize(iconWidth, fontInfo: Iconfont.brandsFont))
                        .frame(width: iconWidth)
                    Text("应用商店")
                }.frame(height: iconWidth).onTapGesture {
                    if UIApplication.shared.canOpenURL(storeURL) {
                        UIApplication.shared.open(storeURL)
                    }
                }
            }
            Section(header: Text("")) {
                HStack {
                    Text("\u{f1e0}")
                        .font(Iconfont.fontOfSize(iconWidth, fontInfo: Iconfont.solidFont))
                        .frame(width: iconWidth)
                    Text("分享")
                }.frame(height: iconWidth).onTapGesture {
                    showShared = true
                }.sheet(isPresented: $showShared) {
                    ActivityViewController(activityItems: [storeURL])
                }
                HStack {
                    Text("\u{f126}")
                        .font(Iconfont.fontOfSize(iconWidth, fontInfo: Iconfont.solidFont))
                        .frame(width: iconWidth)
                    Text("版本")
                    Spacer()
                    Text({ () -> String in
                        if let dict = Bundle.main.infoDictionary, let title = dict["CFBundleShortVersionString"] as? String {
                            return title
                        } else {
                            return ""
                    } }()).foregroundColor(Color(UIColor.secondaryLabel))
                }.frame(height: iconWidth)
            }
            Section(header: Text("")) {
                HStack {
                    Text("\u{f0e3}")
                        .font(Iconfont.fontOfSize(iconWidth, fontInfo: Iconfont.solidFont))
                        .frame(width: iconWidth)
                    Toggle("震动提示", isOn: $settingObservable.shock)
                }.frame(height: cellHeight)
            }
        }.navigationTitle("设置")
    }

    private let githubURL: URL = {
        guard let url = URL(string: "https://github.com/thisfin/SwiftQRCodeScan") else {
            fatalError()
        }
        return url
    }()

    private let storeURL: URL = {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id1196789571") else {
            fatalError()
        }
        return url
    }()

    private let iconWidth: CGFloat = 20
    private let cellHeight: CGFloat = 44

    @UserDefaultsWrapper("hello", defaultValue: "name")
    private var name1: String

    @UserDefaultsWrapper("hello")
    private var name2: String?
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
