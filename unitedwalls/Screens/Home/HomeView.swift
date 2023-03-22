//
//  HomeView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 6) {
                ForEach(Array(apiManager.walls.enumerated()), id:\.element._id) { index, wall in
                    Button {
                        apiManager.loadWallScreenWalls(walls: apiManager.walls)
                        contentViewViewModel.changeWallIndex(index: index)
                        contentViewViewModel.changeOpacity(opacity: 0.75)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            contentViewViewModel.openWallScreenView()
                        }
                    } label: {
                        WebImage(url: URL(string: wall.file_url))
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFill()
                            .frame(width: UIScreen.screenWidth, height: 420, alignment: .center)
                            .background(Color.theme.bgTertiaryColor)
                            .cornerRadius(18)
                            
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                    .onAppear {
                        if apiManager.walls.count != apiManager.wallTotalCount {
                            if index == apiManager.walls.count - 5 {
                                apiManager.loadWalls()
                            }
                        }
                    }
                    if index % 4 == 0 && index > 0 {
                        #if DEBUG
                        VStack {
                            Spacer()
                            SwiftUIBannerAd(adPosition: .top, adUnitId: "ca-app-pub-3940256099942544/2934735716")
                        }
                        .frame(width: UIScreen.screenWidth, height: 70)
                        #else
                        VStack {
                            Spacer()
                            SwiftUIBannerAd(adPosition: .top, adUnitId: "ca-app-pub-2689519261612254/4973208582")
                        }
                        .frame(width: UIScreen.screenWidth, height: 70)
                        #endif
                    }
                    if apiManager.loadingWalls {
                        VStack {
                            Spacer()
                            ProgressView().padding()
                        }
                        .frame(width: UIScreen.screenWidth, height: 70)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(x: contentViewViewModel.homeViewOpened ? 0 : -UIScreen.screenWidth)
        .opacity(contentViewViewModel.homeViewOpened ? 1 : 0)
        .animation(.spring(), value: contentViewViewModel.homeViewOpened)
    }
}
