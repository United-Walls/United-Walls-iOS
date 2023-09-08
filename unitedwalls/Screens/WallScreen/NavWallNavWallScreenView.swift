//
//  NavWallNavWallScreenView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-08-11.
//

import SwiftUI
import SDWebImageSwiftUI

struct NavWallNavWallScreenView: View {
    @State var selectedWall: Wall? = nil
    @State private var saved: Bool = false
    @State var showInfo: Bool = false
    @State var addedBy: String? = nil
    @State var categoryName: String? = nil
    @State private var showShareSheet = false
    @State private var loading = false
    
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var favouriteWallsStore: FavouriteWallsStore
    
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
        ZStack(alignment: .bottomTrailing) {
            WebImage(url: URL(string: selectedWall?.thumbnail_url ?? ""))
                .purgeable(true)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .blur(radius: 50)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .center)
            
            WebImage(url: URL(string: selectedWall?.file_url ?? ""))
                .purgeable(true)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .pinchToZoom()
                .frame(width: UIScreen.screenWidth - 30, height: UIScreen.screenHeight - 180, alignment: .top)
                .background(Color.theme.bgTertiaryColor)
                .cornerRadius(18)
                .padding(.bottom, 6)
                .shadow(radius: 20, x: 3, y: 12)
                .offset(x: -UIScreen.screenWidth + (UIScreen.screenWidth - 30/2), y: -96)
            
            VStack(alignment: .center) {
                Text("Wallpaper saved in the Photos App").padding(12).background(Color.theme.bgTertiaryColor).cornerRadius(100).frame(width: 300, height: 30).shadow(radius: 20, x: 3, y: 12).frame(maxWidth: .infinity, maxHeight: UIScreen.screenHeight).offset(y: saved ?  -(UIScreen.screenHeight - chevronPosition) : -(UIScreen.screenHeight - 440)).opacity(saved ? 1 : 0).animation(.spring(), value: saved)
            }
            
            VStack(spacing: 0) {
                NavigationLink(destination: CategoryNavWallScreenView(selectedCategoryId: selectedWall?.category, selectedUploaderID: selectedWall?.creator)) {
                    HStack(spacing: 4) {
                        Text("Category - ")
                            .font(Font.subheadline)
                        Text(categoryName ?? "")
                            .font(Font.footnote)
                    }
                    .padding(12)
                    .frame(width: 230, alignment: .leading)
                    .background(Color.theme.bgTertiaryColor.opacity(0.5))
                    .cornerRadius(100, corners: [.topLeft, .topRight])
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                NavigationLink(destination: UploaderNavWallScreenView(selectedCategoryId: selectedWall?.category, selectedUploaderID: selectedWall?.creator)) {
                    HStack(spacing: 4) {
                        Text("Creator - ")
                            .font(Font.subheadline)
                        Text("@\(addedBy ?? "")")
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
                    if let index = favouriteWallsStore.walls.firstIndex(where: {$0 == selectedWall?._id ?? ""}) {
                        favouriteWallsStore.walls.remove(at: index)
                        self.apiManager.addToServer(wallId: selectedWall?._id ?? "", api: "removeFav")
                    } else {
                        favouriteWallsStore.walls.insert(selectedWall?._id ?? "", at: 0)
                    }
                    FavouriteWallsStore.save(walls: favouriteWallsStore.walls) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        } else {
                            self.apiManager.addToServer(wallId: selectedWall?._id ?? "", api: "addFav")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: favouriteWallsStore.walls.contains(where: {$0 == selectedWall?._id ?? ""}) ? "heart.fill" : "heart")
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
                    let inputImage =  UIImage(data: try! Data(contentsOf: URL(string: selectedWall?.file_url ?? "")!))!
                    ShareSheet(photo: inputImage)
                }

                //Download Button
                Button {
                    self.loading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        let inputImage =  UIImage(data: try! Data(contentsOf: URL(string: selectedWall?.file_url ?? "")!))!
                        
                        let imageSaver = PhotoManager(albumName: "United Walls")
                        imageSaver.save(inputImage) { completed, error in
                            if completed {
                                self.loading = false
                                saved = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    saved = false
                                    self.apiManager.addToServer(wallId: selectedWall?._id ?? "", api: "addDownloaded")
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
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea(.all))
    }
}
