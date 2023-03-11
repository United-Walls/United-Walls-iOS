//
//  AboutView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-09.
//

import SwiftUI
import SDWebImageSwiftUI

struct AboutView: View {
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 114)
            Container {
                Text("About")
                    .font(Font.title)
                Text("United Walls is an App created with love by the United Setups community in Telegram. All Wallpapers are provided by the community to share them with you. Enjoy your devices with our handcrafted beautiful and artistic Designs.")
            }
            Container {
                Text("Links")
                    .font(Font.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    UIApplication.shared.open(URL(string: "https://t.me/unitedsetups")!)
                } label: {
                    Text("• Telegram")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                Button {
                    UIApplication.shared.open(URL(string: "https://github.com/United-Walls")!)
                } label: {
                    Text("• GitHub")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
            }
            Container {
                Text("Credits")
                    .font(Font.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 12) {
                    WebImage(url: URL(string: "https://github.com/paraskcd1315.png"))
                        .resizable()
                        .frame(width: 64, height: 64)
                        .scaledToFit()
                        .cornerRadius(50)
                        .shadow(radius: 12, x: 3, y: 12)
                    
                    VStack {
                        Text("Paras KCD")
                            .font(Font.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("iOS, Android, Bot and Server Developer")
                            .font(Font.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .onTapGesture {
                    UIApplication.shared.open(URL(string: "https://paraskcd.com")!)
                }
                
                HStack(spacing: 12) {
                    Image("usLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .cornerRadius(50)
                        .shadow(radius: 12, x: 3, y: 12)
                    
                    VStack {
                        Text("The Community")
                            .font(Font.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Wallpaper Uploaders")
                            .font(Font.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .onTapGesture {
                    UIApplication.shared.open(URL(string: "https://t.me/unitedsetups")!)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(x: contentViewViewModel.aboutViewOpened ? 0 : -UIScreen.screenWidth)
        .opacity(contentViewViewModel.aboutViewOpened ? 1 : 0)
        .animation(.spring(), value: contentViewViewModel.aboutViewOpened)
    }
}

