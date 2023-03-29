//
//  PrivacyPolicyView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-27.
//

import SwiftUI
import SDWebImageSwiftUI

struct PrivacyPolicyView: View {
    @EnvironmentObject var privacyPolicyStore: PrivacyPolicyStore
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 114)
            Container {
                Text("Privacy Policy")
                    .font(Font.title)
                Text("In order to be able to use the App, you need to Accept our Privacy Policy.")
            }
            Container {
                HStack {
                    Button("View\nPrivacy Policy") {
                        UIApplication.shared.open(URL(string: "https://united-walls.github.io/Privacy-Policy")!)
                    }
                    .buttonStyle(.plain)
                    .padding(5)
                    .multilineTextAlignment(.center)
                    .frame(width: 150)
                    .background(Color.theme.bgTertiaryColor)
                    .cornerRadius(18)
                    Button("Accept\nPrivacy Policy") {
                        privacyPolicyStore.save(accepted: true) { result in
                            switch result {
                            case .failure(let error):
                                fatalError(error.localizedDescription)
                            case .success(let accepted):
                                privacyPolicyStore.accepted = accepted
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(5)
                    .multilineTextAlignment(.center)
                    .frame(width: 150)
                    .background(Color.theme.bgTertiaryColor)
                    .cornerRadius(18)
                }
            }
            Container {
                Text("About")
                    .font(Font.title)
                Text("Enjoy your devices with our handcrafted, beautiful and artistic designs.\n\nUnited Walls is an app created by the United Setups community in Telegram to provide users with unique wallpapers that are sure to make a statement on any device.\n\nOur community of dedicated users and designers work tirelessly to ensure each wallpaper reflects the love we put into crafting it - so you can be confident knowing only high-quality art will grace your device's display!")
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
        .offset(x: !privacyPolicyStore.accepted ? 0 : -UIScreen.screenWidth)
        .opacity(!privacyPolicyStore.accepted ? 1 : 0)
        .animation(.spring(), value: !privacyPolicyStore.accepted)
    }
}
