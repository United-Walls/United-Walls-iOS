//
//  UploaderView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-07-14.
//

import SwiftUI
import SDWebImageSwiftUI

struct UploaderView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    @EnvironmentObject var favouriteWallsStore: FavouriteWallsStore
    @State private var showingSheet = false
    @State private var saved: Bool = false
    @State var loading = false
    
    var body: some View {
        ZStack {
            ScrollView {
                if apiManager.selectedUploader != nil && apiManager.selectedUploader!.avatar_file_url != nil {
                    ZStack(alignment: .bottom) {
                        WebImage(url: URL(string: apiManager.selectedUploader!.avatar_file_url!))
                            .purgeable(true)
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFill()
                            .frame(height: 320)
                            .background(Color.theme.bgTertiaryColor)
                            .padding(.bottom, 12)
                            .cornerRadius(18)
                        
                        Rectangle().foregroundColor(Color.clear).background(LinearGradient(gradient: Gradient(colors: [Color.theme.bgColor.opacity(0.85), .clear]), startPoint: .bottom, endPoint: .top)).frame(maxWidth: .infinity).cornerRadius(18, corners: [.bottomRight, .bottomLeft])
                    }
                    .frame(height: 320)
                    
                    Spacer()
                        .frame(height: 30)
                    
                } else {
                    Spacer()
                        .frame(height: 120)
                }
                HStack {
                    Text(apiManager.selectedUploader?.username ?? "Creator")
                        .font(.title2)
                    Spacer()
                }
                .padding(.horizontal, 15)
                
                if apiManager.selectedUploader != nil {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(Array(apiManager.selectedUploader!.walls.enumerated()), id: \.element._id) { index, wall in
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
                                if apiManager.selectedUploader!.walls.count != apiManager.uploaderWallsTotalCount {
                                    if index == apiManager.selectedUploader!.walls.count - 5 {
                                        apiManager.loadUploaderById(userId: apiManager.selectedUploader!._id, initialize: false)
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
                            .sheet(isPresented: $showingSheet, onDismiss: {
                                contentViewViewModel.changeWallIndex(index: 0)
                                contentViewViewModel.changeOpacity(opacity: 0)
                            }) {
                                UploaderWallScreenView()
                            }
                        }
                        
                        Spacer()
                            .frame(height: 90)
                        Spacer()
                            .frame(height: 90)
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
        .frame(maxWidth: UIScreen.screenWidth - 5, maxHeight: .infinity)
        .offset(x: contentViewViewModel.uploaderViewOpened ? 18 : -UIScreen.screenWidth)
        .opacity(contentViewViewModel.uploaderViewOpened ? 1 : 0)
        .animation(.spring(), value: contentViewViewModel.uploaderViewOpened)
    }
}
