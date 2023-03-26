//
//  FavouriteWallsView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-13.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavouriteWallsView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var favouriteWallsStore: FavouriteWallsStore
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                Spacer()
                    .frame(height: 120)
                Spacer()
                    .frame(height: 120)
                ForEach(Array(apiManager.favouriteWalls.enumerated()), id:\.element._id) { index, wall in
                    Button {
                        apiManager.loadWallScreenFavouriteWalls(walls: apiManager.favouriteWalls)
                        contentViewViewModel.changeWallIndex(index: index)
                        contentViewViewModel.changeOpacity(opacity: 0.75)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            contentViewViewModel.openFavouriteWallScreenView()
                        }
                    } label: {
                        WebImage(url: URL(string: wall.thumbnail_url))
                            .cancelOnDisappear(true)
                            .purgeable(true)
                            .retryOnAppear(true)
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFill()
                            .frame(height: 200)
                            .background(Color.theme.bgTertiaryColor)
                            .cornerRadius(18)
                            .padding(.leading, index % 2 == 0 ? 10 : 0)
                            .padding(.trailing, index % 2 != 0 ? 10 : 0)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 0).onChanged({ _ in
                        //do nothing
                    }))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(x: contentViewViewModel.favouriteWallsViewOpened ? 0 : -UIScreen.screenWidth)
        .opacity(contentViewViewModel.favouriteWallsViewOpened ? 1 : 0)
        .animation(.spring(), value: contentViewViewModel.favouriteWallsViewOpened)
    }
}
