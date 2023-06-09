//
//  MostLikedView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-04-16.
//

import SwiftUI
import SDWebImageSwiftUI

struct MostLikedView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    @State private var showingSheet = false
    
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 120)
            
            HStack {
                Text("Most Liked")
                    .font(.title2)
                Spacer()
            }
            .padding(.horizontal, 15)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                if apiManager.mostFavouritedWalls.count != 0 {
                    ForEach(Array(apiManager.mostFavouritedWalls.enumerated()), id:\.element._id) { index, wall in
                        Button {
                            DispatchQueue.main.async {
                                contentViewViewModel.changeWallIndex(index: index)
                                contentViewViewModel.changeOpacity(opacity: 0.75)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    showingSheet.toggle()
                                }
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
                        .sheet(isPresented: $showingSheet, onDismiss: {
                            contentViewViewModel.changeWallIndex(index: 0)
                            contentViewViewModel.changeOpacity(opacity: 0)
                        }) {
                            MostLikedWallScreenView()
                        }
                    }
                }
                Spacer()
                    .frame(height: 90)
                Spacer()
                    .frame(height: 90)
            }
        }
        .frame(maxWidth: UIScreen.screenWidth - 5, maxHeight: .infinity)
        .offset(x: contentViewViewModel.mostLikedScreenOpened ? 18 : -UIScreen.screenWidth)
        .opacity(contentViewViewModel.mostLikedScreenOpened ? 1 : 0)
        .animation(.spring(), value: contentViewViewModel.mostLikedScreenOpened)
    }
}
