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
    @EnvironmentObject var favouriteWallsStore: FavouriteWallsStore
    @EnvironmentObject var privacyPolicyStore: PrivacyPolicyStore
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var showNetworkAlert = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if privacyPolicyStore.accepted {
                Group {
                    HomeView()
                    AboutView()
                    UploadersView()
                    CategoriesView()
                    MostLikedView()
                    MostPopularView()
                    if favouriteWallsStore.walls.count != 0 || apiManager.favouriteWalls.count != 0 {
                        FavouriteWallsView()
                    }
                    if apiManager.selectedCategory != nil {
                        CategoryView()
                    }
                    if apiManager.selectedUploader != nil {
                        UploaderView()
                    }
                }
                .onChange(of: networkMonitor.isConnected) { connection in
                    showNetworkAlert = connection == false
                }
                .alert(
                    "Network connection seems to be offline.",
                    isPresented: $showNetworkAlert
                ) {}
                
               Rectangle().foregroundColor(Color.clear).background(LinearGradient(gradient: Gradient(colors: [Color.theme.bgColor.opacity(0.1), .clear]), startPoint: .leading, endPoint: .trailing)).frame(maxWidth: 50, maxHeight: .infinity)
                   .highPriorityGesture(
                       DragGesture()
                           .onChanged { gesture in
                               if gesture.translation.height < 5 {
                                   contentViewViewModel.changeOffset(offset: gesture.translation.width)
                               }
                           }
                           .onEnded({ value in
                               if value.translation.width > 0 {
                                   if value.translation.width > 5 {
                                       DispatchQueue.main.async {
                                           contentViewViewModel.openSidebar()
                                           contentViewViewModel.changeOffset(offset: 0)
                                       }
                                   }
                               } else {
                                   DispatchQueue.main.async {
                                       contentViewViewModel.closeSidebar()
                                       contentViewViewModel.changeOffset(offset: 0)
                                   }
                               }
                           })
                   )
               Topbar(toggleSidebar: { contentViewViewModel.toggleSidebar() })
               Color.black.opacity(contentViewViewModel.opacity)
               .onTapGesture {
                   if contentViewViewModel.sidebarOpened {
                       contentViewViewModel.closeSidebar()
                       contentViewViewModel.changeOffset(offset: 0)
                   }
               }
               #if DEBUG
               SwiftUIBannerAd(adPosition: .bottom, adUnitId: "ca-app-pub-3940256099942544/2934735716")
                   .padding()
               #else
               SwiftUIBannerAd(adPosition: .bottom, adUnitId: "ca-app-pub-2689519261612254/7839260675")
                   .padding()
               #endif
               Drawer(opened: contentViewViewModel.sidebarOpened)
            } else {
                PrivacyPolicyView()
                Topbar(toggleSidebar: { contentViewViewModel.toggleSidebar() })
                Color.black.opacity(contentViewViewModel.opacity)
                .onTapGesture {
                    if contentViewViewModel.sidebarOpened {
                        contentViewViewModel.closeSidebar()
                        contentViewViewModel.changeOffset(offset: 0)
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.theme.bgTertiaryColor)
        .foregroundColor(Color.theme.textColor)
        .animation(.spring().speed(1.5), value: contentViewViewModel.opacity)
        .edgesIgnoringSafeArea(.vertical)
    }
}
