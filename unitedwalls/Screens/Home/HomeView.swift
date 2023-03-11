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
            if apiManager.loadingWalls {
                VStack {
                    ProgressView()
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            LazyVStack(spacing: 0) {
                ForEach(Array(apiManager.walls.enumerated()), id:\.element._id) { index, wall in
                    Button {
                        contentViewViewModel.closeHomeView()
                        contentViewViewModel.closeTopBar()
                        apiManager.loadWallScreenWalls()
                        contentViewViewModel.changeWallIndex(index: index)
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
                            .padding(.bottom, 6)
                            .shadow(radius: 20, x: 3, y: 12)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(x: contentViewViewModel.homeViewOpened ? 0 : -UIScreen.screenWidth)
        .opacity(contentViewViewModel.homeViewOpened ? 1 : 0)
        .animation(.spring(), value: contentViewViewModel.homeViewOpened)
    }
}
