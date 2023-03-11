//
//  Topbar.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import SwiftUI

struct Topbar: View {
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    var toggleSidebar: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            Color.theme.bgColor.frame(height: 20)
            HStack {
                Button {
                    toggleSidebar()
                } label: {
                    Image(colorScheme == .light ? "MenuLight" : "MenuDark")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 24, height: 24)
                .buttonStyle(.plain)
                .padding(.leading, 24)
                
                Text("United Walls")
                    .frame(minWidth: UIScreen.screenWidth - (24 + 18), alignment: .center)
                    .offset(x: -24)
                    .font(Font.custom("Billion Dreams", size: 48))
                    .shadow(radius: 12, x: 3, y: 6)
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120)
            .background(LinearGradient(gradient: Gradient(colors: [Color.theme.bgColor, Color.theme.bgColor.opacity(0.8), .clear]), startPoint: .top, endPoint: .bottom))
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .opacity(contentViewViewModel.topBarOpened ? 1 : 0)
        .animation(.spring(), value: contentViewViewModel.topBarOpened)
    }
}
