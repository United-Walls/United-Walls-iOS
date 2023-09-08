//
//  WallOfDayScreenView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-04-17.
//

import SwiftUI
import SDWebImageSwiftUI

struct WallOfDayScreenView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    @EnvironmentObject var favouriteWallsStore: FavouriteWallsStore
    
    @State var showInfo: Bool = false
    @State private var offset: CGSize = .zero
    @State private var currentImage: UIImage?
    @State private var saved: Bool = false
    @State private var showShareSheet = false
    @State private var loading = false
    @State private var changeOpacity: Double = 1
    
    var chevronPosition: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhone14Pro:
            return 500
        case .iPhones_6_6s_7_8:
            return 400
        case .iPhoneX_iPhoneXS:
            return 475
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            return 440
        case .iPhone14_iPhone13_iPhone12:
            return 490
        default:
            return 540
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                WebImage(url: URL(string: apiManager.wallOfDay?.thumbnail_url ?? ""))
                    .purgeable(true)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .center)
                    .blur(radius: 50)
                    .opacity(changeOpacity)
                    .animation(.easeInOut, value: changeOpacity)
                
                TabView {
                    WebImage(url: URL(string: apiManager.wallOfDay?.file_url ?? ""))
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
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onAppear {
                    apiManager.loadUploaderFromWallId(wallId: apiManager.wallOfDay?._id ?? "")
                }
                
                VStack(alignment: .center) {
                    Text("Wallpaper saved in the Photos App").padding(12).background(Color.theme.bgTertiaryColor).cornerRadius(100).frame(width: 300, height: 30).shadow(radius: 20, x: 3, y: 12).frame(maxWidth: .infinity, maxHeight: UIScreen.screenHeight).offset(y: saved ?  -(UIScreen.screenHeight - chevronPosition) : -(UIScreen.screenHeight - 440)).opacity(saved ? 1 : 0).animation(.spring(), value: saved)
                }
                
                VStack(spacing: 0) {
                    NavigationLink(destination: CategoryNavWallScreenView(selectedCategoryId: apiManager.wallOfDay?.category, selectedUploaderID: apiManager.wallOfDay?.creator)) {
                        HStack(spacing: 4) {
                            Text("Category - ")
                                .font(Font.subheadline)
                            if apiManager.categories.filter({ category in category._id == apiManager.wallOfDay?.category }).count > 0 {
                                Text(apiManager.categories.filter{ category in category._id == apiManager.wallOfDay?.category }[0].name )
                                    .font(Font.footnote)
                            }
                        }
                        .padding(12)
                        .frame(width: 230, alignment: .leading)
                        .background(Color.theme.bgTertiaryColor.opacity(0.5))
                        .cornerRadius(100, corners: [.topLeft, .topRight])
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    NavigationLink(destination: UploaderNavWallScreenView(selectedCategoryId: apiManager.wallOfDay?.category, selectedUploaderID: apiManager.wallOfDay?.creator)) {
                        HStack(spacing: 4) {
                            Text("Creator - ")
                                .font(Font.subheadline)
                            Text("@\(apiManager.addedBy)")
                                .font(Font.footnote)
                        }
                        .padding(12)
                        .frame(width: 230, alignment: .leading)
                        .background(Color.theme.bgTertiaryColor.opacity(0.5))
                        .cornerRadius(100, corners: [.bottomLeft, .bottomRight])
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .opacity(showInfo ? 1 : 0)
                .animation(.spring(), value: showInfo)
                .padding(.leading, 24)
                .padding(.bottom, 18)
                .offset(y: -72)

                VStack {
                    //Info
                    Button {
                        showInfo = !showInfo
                    } label: {
                        HStack {
                            Image(systemName: !showInfo ? "info.circle" : "info.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                    }
                    .buttonStyle(.plain)

                    //Favourite
                    Button {
                        if let index = favouriteWallsStore.walls.firstIndex(where: {$0 == apiManager.wallOfDay?._id ?? ""}) {
                            favouriteWallsStore.walls.remove(at: index)
                            self.apiManager.addToServer(wallId: apiManager.wallOfDay?._id ?? "", api: "removeFav")
                        } else {
                            favouriteWallsStore.walls.insert(apiManager.wallOfDay?._id ?? "", at: 0)
                        }
                        FavouriteWallsStore.save(walls: favouriteWallsStore.walls) { result in
                            if case .failure(let error) = result {
                                fatalError(error.localizedDescription)
                            } else {
                                self.apiManager.addToServer(wallId: apiManager.wallOfDay?._id ?? "", api: "addFav")
                            }
                        }
                        apiManager.loadFavouriteWalls(wallIds: favouriteWallsStore.walls)
                    } label: {
                        HStack {
                            Image(systemName: favouriteWallsStore.walls.contains(where: {$0 == apiManager.wallOfDay?._id ?? ""}) ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                    }
                    .buttonStyle(.plain)

                    //Share Button
                    Button {
                        showShareSheet.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $showShareSheet) {
                        let inputImage =  UIImage(data: try! Data(contentsOf: URL(string: apiManager.wallOfDay?.file_url ?? "")!))!
                        ShareSheet(photo: inputImage)
                    }

                    Button {
                        self.loading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            DispatchQueue.main.async {
                                let inputImage =  UIImage(data: try! Data(contentsOf: URL(string: apiManager.wallOfDay?.file_url ?? "")!))!
                                
                                let imageSaver = PhotoManager(albumName: "United Walls")
                                imageSaver.save(inputImage) { completed, error in
                                    if completed {
                                        self.loading = false
                                        saved = true
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                            saved = false
                                            self.apiManager.addToServer(wallId: apiManager.wallOfDay?._id ?? "", api: "addDownloaded")
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.trailing, 32)
                .padding(.bottom, 12)
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
        }
        .offset(y: offset.height)
        .animation(.interactiveSpring(), value: offset)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea(.all))
        .accentColor(Color.theme.textColor)
    }
}
