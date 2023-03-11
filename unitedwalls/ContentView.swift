//
//  ContentView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HomeView()
            AboutView()
            Topbar(toggleSidebar: { contentViewViewModel.toggleSidebar() })
            Color.black.opacity(contentViewViewModel.opacity)
            .onTapGesture {
                if contentViewViewModel.sidebarOpened {
                    contentViewViewModel.closeSidebar()
                }
            }
            Drawer(opened: contentViewViewModel.sidebarOpened)
            if apiManager.modifiedWalls.count > 0 {
                WallScreenView()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.theme.bgTertiaryColor)
        .foregroundColor(Color.theme.textColor)
        .gesture(
            DragGesture()
                .onEnded({ value in
                    if value.translation.width > 0 {
                        if value.translation.width > 5 {
                            contentViewViewModel.openSidebar()
                        }
                    } else {
                        contentViewViewModel.closeSidebar()
                    }
                })
        )
        .animation(.spring().speed(1.5), value: contentViewViewModel.opacity)
        .edgesIgnoringSafeArea(.vertical)
    }
}
