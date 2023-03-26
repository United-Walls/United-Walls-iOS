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
    
    @State var loading = false
    @State private var saved: Bool = false
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    Spacer()
                        .frame(height: 120)
                    Spacer()
                        .frame(height: 120)
                    ForEach(Array(apiManager.walls.enumerated()), id:\.element._id) { index, wall in
                        Button {
                            apiManager.loadWallScreenWalls(walls: apiManager.walls)
                            contentViewViewModel.changeWallIndex(index: index)
                            contentViewViewModel.changeOpacity(opacity: 0.75)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                contentViewViewModel.openWallScreenView()
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
                                    apiManager.loadWalls()
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
                    if apiManager.loadingWalls {
                        VStack {
                            Spacer()
                            ProgressView().padding()
                        }
                        .frame(width: UIScreen.screenWidth, height: 70)
                    }
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(x: contentViewViewModel.homeViewOpened ? 0 : -UIScreen.screenWidth)
        .opacity(contentViewViewModel.homeViewOpened ? 1 : 0)
        .animation(.spring(), value: contentViewViewModel.homeViewOpened)
    }
}
