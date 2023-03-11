//
//  Drawer.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import SwiftUI

struct Drawer: View {
    var opened: Bool = false
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Spacer()
                .frame(height: 60)
            Image(colorScheme == .dark ? "DrawerImageDark" : "DrawerImageLight")
                .resizable()
                .scaledToFit()
            DrawerItem(
                icon: "house.fill",
                name: "Home",
                active: contentViewViewModel.homeViewOpened,
                onClick: {
                    contentViewViewModel.openHomeView()
                    contentViewViewModel.closeSidebar()
                    if contentViewViewModel.aboutViewOpened {
                        contentViewViewModel.closeAboutView()
                    }
                }
            )
            DrawerItem(
                icon: "info.circle.fill",
                name: "About",
                active: contentViewViewModel.aboutViewOpened,
                onClick: {
                    contentViewViewModel.openAboutView()
                    contentViewViewModel.closeSidebar()
                    if contentViewViewModel.homeViewOpened {
                        contentViewViewModel.closeHomeView()
                    }
                }
            )
            DrawerItem(
                icon: "filemenu.and.selection",
                name: "Categories",
                active: false,
                onClick: {}
            )
            LazyVStack {
                ForEach(apiManager.categories, id: \._id) { category in
                    Button {
                        
                    } label: {
                        Text(category.name)
                            .fontWeight(.light)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 36)
                            .padding(12)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 12)
            .background(Color.theme.bgTertiaryColor)
            .cornerRadius(36)
        }
        .frame(minWidth: 0, maxWidth: 234, minHeight: 0, maxHeight: .infinity)
        .background(Color.theme.bgColor)
        .offset(x: opened ? 0 : -234)
        .animation(.spring().speed(1.5), value: opened)
    }
}

struct DrawerItem: View {
    var icon: String
    var name: String
    var active: Bool
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text(name)
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 18)
            .padding(12)
            .background(active ? Color.theme.bgTertiaryColor : .clear)
            .cornerRadius(36)
        }
        .buttonStyle(DrawerButtonStyle())
    }
}

struct DrawerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .background(configuration.isPressed ? Color.theme.bgTertiaryColor : .clear)
            .cornerRadius(36)
            .animation(.easeOut, value: configuration.isPressed)
            .padding(.horizontal, 12)
    }
}
