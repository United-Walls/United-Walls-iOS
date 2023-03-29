//
//  CategoryWallScreenView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-13.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryWallScreenView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    @EnvironmentObject var favouriteWallsStore: FavouriteWallsStore
    
    @State var showInfo: Bool = false
    @State var selectedWall: Wall = Wall(_id: "", category: "", createdAt: "", file_id: "", thumbnail_id: "", file_name: "", file_url: "", thumbnail_url: "", mime_type: "", updatedAt: "", addedBy: "")
    @State private var offset: CGSize = .zero
    @State private var currentImage: UIImage?
    @State private var saved: Bool = false
    @State private var showShareSheet = false
    @State private var loading = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $contentViewViewModel.wallIndex) {
                ForEach(Array(apiManager.modifiedSelectedCategoryWalls.enumerated()), id: \.element._id) { index, wall in
                    WebImage(url: URL(string: wall.file_url))
                        .purgeable(true)
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFill()
                        .pinchToZoom()
                        .frame(width: UIScreen.screenWidth - 30, height: UIScreen.screenHeight - 180, alignment: .center)
                        .background(Color.theme.bgTertiaryColor)
                        .cornerRadius(18)
                        .padding(.bottom, 6)
                        .shadow(radius: 20, x: 3, y: 12)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: contentViewViewModel.wallIndex) { index in
                selectedWall = apiManager.modifiedSelectedCategoryWalls[index]
            }
            .onAppear {
                selectedWall = apiManager.modifiedSelectedCategoryWalls[contentViewViewModel.wallIndex]
            }
            
            VStack(alignment: .center) {
                Color.theme.textColor.frame(width: 30, height: 3).cornerRadius(100).frame(maxWidth: .infinity, maxHeight: UIScreen.screenHeight).offset(y: -(UIScreen.screenHeight - 540)).opacity(offset.height >= -10 && offset.height <= 10 ? 1 : 0).animation(.interactiveSpring(), value: offset)
            }
            
            VStack(alignment: .center) {
                Image(systemName: "chevron.down").resizable().scaledToFit().frame(width: 30, height: 30).frame(maxWidth: .infinity, maxHeight: UIScreen.screenHeight).offset(y: -(UIScreen.screenHeight - 540)).opacity(offset.height > 10 ? 1 : 0).animation(.interactiveSpring(), value: offset)
            }
            
            VStack(alignment: .center) {
                Image(systemName: "chevron.up").resizable().scaledToFit().frame(width: 30, height: 30).frame(maxWidth: .infinity, maxHeight: UIScreen.screenHeight).offset(y: -(UIScreen.screenHeight - 540)).opacity(offset.height < -10 ? 1 : 0).animation(.interactiveSpring(), value: offset)
            }
            
            VStack(alignment: .center) {
                Text("Wallpaper saved in the Photos App").padding(12).background(Color.theme.bgTertiaryColor).cornerRadius(100).frame(width: 300, height: 30).shadow(radius: 20, x: 3, y: 12).frame(maxWidth: .infinity, maxHeight: UIScreen.screenHeight).offset(y: saved ?  -(UIScreen.screenHeight - 540) : -(UIScreen.screenHeight - 440)).opacity(saved ? 1 : 0).animation(.spring(), value: saved)
            }
            
            VStack(spacing: 0) {
                HStack(spacing: 4) {
                    Text("Name - ")
                        .font(Font.subheadline)
                    Text(selectedWall.file_name)
                        .font(Font.footnote)
                }
                .padding(12)
                .frame(width: 230, alignment: .leading)
                .background(Color.theme.bgTertiaryColor.opacity(0.5))
                .cornerRadius(100, corners: [.topLeft, .topRight])
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 4) {
                    Text("Added by - ")
                        .font(Font.subheadline)
                    Text(selectedWall.addedBy)
                        .font(Font.footnote)
                }
                .padding(12)
                .frame(width: 230, alignment: .leading)
                .background(Color.theme.bgTertiaryColor.opacity(0.5))
                .cornerRadius(100, corners: [.bottomLeft, .bottomRight])
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .opacity(showInfo ? 1 : 0)
            .animation(.spring(), value: showInfo)
            .padding(.leading, 24)
            .padding(.bottom, 18)
            .offset(y: -72)

            VStack {
                //Info
                if #available(iOS 15.0, *) {
                    Button {
                        showInfo = !showInfo
                    } label: {
                        Image(systemName: !showInfo ? "info.circle" : "info.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 36, height: 36)
                    .background(.ultraThinMaterial)
                    .cornerRadius(100)
                    
                } else {
                    // Fallback on earlier versions
                    Button {
                        showInfo = !showInfo
                    } label: {
                        Image(systemName: !showInfo ? "info.circle" : "info.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 36, height: 36)
                    .background(Color.theme.bgTertiaryColor.opacity(0.5))
                    .cornerRadius(100)
                }

                //Favourite
                if #available(iOS 15.0, *) {
                    Button {
                        if let index = favouriteWallsStore.walls.firstIndex(where: {$0 == selectedWall._id}) {
                            favouriteWallsStore.walls.remove(at: index)
                        } else {
                            favouriteWallsStore.walls.insert(selectedWall._id, at: 0)
                        }
                        FavouriteWallsStore.save(walls: favouriteWallsStore.walls) { result in
                            if case .failure(let error) = result {
                                fatalError(error.localizedDescription)
                            }
                        }
                        apiManager.loadFavouriteWalls(wallIds: favouriteWallsStore.walls)
                    } label: {
                        Image(systemName: favouriteWallsStore.walls.contains(where: {$0 == selectedWall._id}) ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 36, height: 36)
                    .background(.ultraThinMaterial)
                    .cornerRadius(100)
                } else {
                    // Fallback on earlier versions
                    Button {
                        if let index = favouriteWallsStore.walls.firstIndex(where: {$0 == selectedWall._id}) {
                            favouriteWallsStore.walls.remove(at: index)
                        } else {
                            favouriteWallsStore.walls.insert(selectedWall._id, at: 0)
                        }
                        FavouriteWallsStore.save(walls: favouriteWallsStore.walls) { result in
                            if case .failure(let error) = result {
                                fatalError(error.localizedDescription)
                            }
                        }
                        apiManager.loadFavouriteWalls(wallIds: favouriteWallsStore.walls)
                    } label: {
                        Image(systemName: "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 36, height: 36)
                    .background(Color.theme.bgTertiaryColor.opacity(0.5))
                    .cornerRadius(100)
                }

                //Share Button
                if #available(iOS 15.0, *) {
                    Button {
                        showShareSheet.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 36, height: 36)
                    .background(.ultraThinMaterial)
                    .cornerRadius(100)
                    .sheet(isPresented: $showShareSheet) {
                        let inputImage =  UIImage(data: try! Data(contentsOf: URL(string: selectedWall.file_url)!))!
                        ShareSheet(photo: inputImage)
                    }
                    
                } else {
                    // Fallback on earlier versions
                    Button {
                        showShareSheet.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 36, height: 36)
                    .background(Color.theme.bgTertiaryColor.opacity(0.5))
                    .cornerRadius(100)
                    .sheet(isPresented: $showShareSheet) {
                        let inputImage =  UIImage(data: try! Data(contentsOf: URL(string: selectedWall.file_url)!))!
                        ShareSheet(photo: inputImage)
                    }
                }

                //Download Button
                if #available(iOS 15.0, *) {
                    Button {
                        self.loading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            let inputImage =  UIImage(data: try! Data(contentsOf: URL(string: selectedWall.file_url)!))!
                            
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
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 36, height: 36)
                    .background(.ultraThinMaterial)
                    .cornerRadius(100)
                    
                } else {
                    // Fallback on earlier versions
                    Button {
                        self.loading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            let inputImage =  UIImage(data: try! Data(contentsOf: URL(string: selectedWall.file_url)!))!
                            
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
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 36, height: 36)
                    .background(Color.theme.bgTertiaryColor.opacity(0.5))
                    .cornerRadius(100)
                }
            }
            .padding(.trailing, 42)
            .padding(.bottom, 18)
            .offset(y: -72)
            
            Color.black.opacity(loading ? 0.75 : 0)

            if loading {
                VStack {
                    ProgressView()
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .offset(y: contentViewViewModel.categoryWallScreenViewOpened ? offset.height : offset.height < 0 ? -UIScreen.screenHeight : UIScreen.screenHeight)
        .animation(.interactiveSpring(), value: offset)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.bgColor)
        .opacity(contentViewViewModel.categoryWallScreenViewOpened ? 1 : 0)
        .simultaneousGesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.width < 5 {
                        offset = gesture.translation
                    }
                }
                .onEnded { _ in
                    if abs(offset.height) > 100 {
                        contentViewViewModel.closeCategoryWallScreenView()
                        contentViewViewModel.changeOpacity(opacity: 0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            apiManager.unloadWallScreenSelectedCategoryWalls()
                        }
                    } else {
                        offset = .zero
                    }
                }
        )
        .animation(.spring(), value: contentViewViewModel.categoryWallScreenViewOpened)
    }
}
