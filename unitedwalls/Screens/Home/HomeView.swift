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
    @EnvironmentObject var favouriteWallsStore: FavouriteWallsStore
    @Environment(\.scenePhase) var scenePhase
    @State private var showingSheet = false
    @State private var showingMostLikedSheet = false
    @State private var showingMostPopularSheet = false
    @State private var showingWallOfDaySheet = false
    
    @State var loading = false
    @State private var saved: Bool = false
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            ScrollView {
                Button {
                    DispatchQueue.main.async {
                        contentViewViewModel.changeOpacity(opacity: 0.75)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showingWallOfDaySheet.toggle()
                        }
                    }
                } label: {
                    ZStack(alignment: .bottom) {
                        WebImage(url: URL(string: apiManager.wallOfDay?.file_url ?? ""))
                            .purgeable(true)
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFill()
                            .frame(height: 412)
                            .background(Color.theme.bgTertiaryColor)
                            .padding(.bottom, 12)
                            .cornerRadius(18)
                            .shadow(radius: 10, x: 0, y: 0)
                        
                        Rectangle().foregroundColor(Color.clear).background(LinearGradient(gradient: Gradient(colors: [Color.theme.bgColor.opacity(0.85), .clear]), startPoint: .bottom, endPoint: .top)).frame(maxWidth: .infinity).cornerRadius(18, corners: [.bottomRight, .bottomLeft])
                        
                        Text("Wall of the Day")
                            .font(.title2)
                            .padding(10)
                            .padding(.bottom, 20)
                    }
                    .frame(height: 412)
                    .sheet(isPresented: $showingWallOfDaySheet, onDismiss: {
                        contentViewViewModel.changeOpacity(opacity: 0)
                    }) {
                        WallOfDayScreenView()
                    }
                }
                Spacer()
                    .frame(height: 30)
                if apiManager.mostFavouritedWalls.count > 0 {
                    HStack {
                        Text("Most Liked")
                            .font(.title2)
                        Spacer()
                        Button {
                            DispatchQueue.main.async {
                                contentViewViewModel.closeHomeView()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    contentViewViewModel.openMostLikedScreenView()
                                }
                            }
                        } label: {
                            HStack {
                                Text("Show more")
                                Image(systemName: "chevron.right")
                            }
                            .padding(12)
                            .padding(.horizontal, 10)
                            .background(Color.theme.bgSecondaryColor)
                            .cornerRadius(18)
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(Array(apiManager.mostFavouritedWalls.enumerated().prefix(5)), id: \.element._id) { index, wall in
                                Button {
                                    DispatchQueue.main.async {
                                        contentViewViewModel.changeWallIndex(index: index)
                                        contentViewViewModel.changeOpacity(opacity: 0.75)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            showingMostLikedSheet.toggle()
                                        }
                                    }
                                } label: {
                                    WebImage(url: URL(string: wall.thumbnail_url))
                                        .purgeable(true)
                                        .resizable()
                                        .indicator(.activity)
                                        .transition(.fade(duration: 0.5))
                                        .scaledToFill()
                                        .frame(width: 150, height: 240)
                                        .background(Color.theme.bgTertiaryColor)
                                        .cornerRadius(18)
                                        .padding(.vertical, 12)
                                        .shadow(radius: 10, x: 0, y: 2)
                                        .padding(.leading, 10)
                                        .padding(.bottom, 5)
                                }
                                .sheet(isPresented: $showingMostLikedSheet, onDismiss: {
                                    contentViewViewModel.changeWallIndex(index: 0)
                                    contentViewViewModel.changeOpacity(opacity: 0)
                                }) {
                                    MostLikedWallScreenView()
                                }
                            }
                        }
                    }
                }
                
                if apiManager.mostDownloadedWalls.count > 0 {
                    HStack {
                        Text("Most Popular")
                            .font(.title2)
                        Spacer()
                        Button {
                            DispatchQueue.main.async {
                                contentViewViewModel.closeHomeView()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    contentViewViewModel.openMostPopularScreenView()
                                }
                            }
                        } label: {
                            HStack {
                                Text("Show more")
                                Image(systemName: "chevron.right")
                            }
                            .padding(12)
                            .padding(.horizontal, 10)
                            .background(Color.theme.bgSecondaryColor)
                            .cornerRadius(18)
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(Array(apiManager.mostDownloadedWalls.enumerated().prefix(5)), id: \.element._id) { index, wall in
                                Button {
                                    DispatchQueue.main.async {
                                        contentViewViewModel.changeWallIndex(index: index)
                                        contentViewViewModel.changeOpacity(opacity: 0.75)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            showingMostPopularSheet.toggle()
                                        }
                                    }
                                } label: {
                                    WebImage(url: URL(string: wall.thumbnail_url))
                                        .purgeable(true)
                                        .resizable()
                                        .indicator(.activity)
                                        .transition(.fade(duration: 0.5))
                                        .scaledToFill()
                                        .frame(width: 150, height: 240)
                                        .background(Color.theme.bgTertiaryColor)
                                        .cornerRadius(18)
                                        .padding(.vertical, 12)
                                        .shadow(radius: 10, x: 0, y: 2)
                                        .padding(.leading, 10)
                                        .padding(.bottom, 5)
                                }
                                .sheet(isPresented: $showingMostPopularSheet, onDismiss: {
                                    contentViewViewModel.changeWallIndex(index: 0)
                                    contentViewViewModel.changeOpacity(opacity: 0)
                                }) {
                                    MostPopularWallScreenView()
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Text("All Wallpapers")
                        .font(.title2)
                    Spacer()
                }
                .padding(.horizontal, 15)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(Array(apiManager.walls.enumerated()), id:\.element._id) { index, wall in
                        Button {
                            DispatchQueue.main.async {
                                contentViewViewModel.changeWallIndex(index: index)
                                contentViewViewModel.changeOpacity(opacity: 0.75)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
                        .onAppear {
                            if index == 0 || index % 8 == 0 {
                                SDImageCache.shared.clearMemory()
                            }
                            if apiManager.walls.count != apiManager.wallTotalCount {
                                if index == apiManager.walls.count - 5 {
                                    apiManager.loadWalls(initialize: false)
                                    SDImageCache.shared.clearMemory()
                                }
                            }
                        }
                        .contextMenu {
                            Button {
                                if let index = favouriteWallsStore.walls.firstIndex(where: {$0 == wall._id}) {
                                    favouriteWallsStore.walls.remove(at: index)
                                } else {
                                    favouriteWallsStore.walls.insert(wall._id, at: 0)
                                }
                                FavouriteWallsStore.save(walls: favouriteWallsStore.walls) { result in
                                    if case .failure(let error) = result {
                                        fatalError(error.localizedDescription)
                                    }
                                }
                            } label: {
                                Label(favouriteWallsStore.walls.contains(where: {$0 == wall._id}) ? "Unfavourite" : "Favourite", systemImage: favouriteWallsStore.walls.contains(where: {$0 == wall._id}) ? "heart.fill" : "heart")
                            }
                            
                            Button {
                                self.loading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    let inputImage =  UIImage(data: try! Data(contentsOf: URL(string: wall.file_url)!))!
                                    
                                    let imageSaver = PhotoManager(albumName: "United Setups")
                                    imageSaver.save(inputImage) { completed, error in
                                        if completed {
                                            self.loading = false
                                            saved = true
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                                saved = false
                                            }
                                        }
                                    }
                                }
                            } label: {
                                Label("Download", systemImage: "square.and.arrow.down")
                            }
                        }
                    }
                    .sheet(isPresented: $showingSheet, onDismiss: {
                        contentViewViewModel.changeWallIndex(index: 0)
                        contentViewViewModel.changeOpacity(opacity: 0)
                    }) {
                        WallScreenView()
                    }
                    
                    
                    if apiManager.loadingWalls {
                        VStack {
                            Spacer()
                            ProgressView().padding()
                        }
                        .frame(width: UIScreen.screenWidth, height: 70)
                    }
                    Spacer()
                        .frame(height: 90)
                    Spacer()
                        .frame(height: 90)
                }
            }
            
            VStack(alignment: .center) {
                Text("Wallpaper saved in the Photos App").padding(12).background(Color.theme.bgTertiaryColor).cornerRadius(100).frame(width: 300, height: 30).shadow(radius: 20, x: 3, y: 12).frame(maxWidth: .infinity, maxHeight: UIScreen.screenHeight).offset(y: saved ?  -(UIScreen.screenHeight - 580) : -(UIScreen.screenHeight - 440)).opacity(saved ? 1 : 0).animation(.spring(), value: saved)
            }
            
            Color.black.opacity(loading ? 0.75 : 0)
            
            if loading {
                VStack {
                    ProgressView()
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: UIScreen.screenWidth - 5, maxHeight: .infinity)
        .offset(x: contentViewViewModel.homeViewOpened ? 18 : -UIScreen.screenWidth)
        .opacity(contentViewViewModel.homeViewOpened ? 1 : 0)
        .animation(.spring(), value: contentViewViewModel.homeViewOpened)
    }
}
