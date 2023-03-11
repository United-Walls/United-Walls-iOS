//
//  WallScreenView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import SwiftUI
import SDWebImageSwiftUI

struct WallScreenView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    @State var showInfo: Bool = false
    @StateObject var UIState: UIStateModel = UIStateModel()
    @State var selectedWall: Wall = Wall(_id: "", category: "", createdAt: "", file_id: "", file_name: "", file_url: "", mime_type: "", updatedAt: "", addedBy: "")
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $contentViewViewModel.wallIndex) {
                ForEach(Array(apiManager.walls.enumerated()), id: \.element._id) { index, wall in
                    WebImage(url: URL(string: wall.file_url))
                        .purgeable(true)
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFill()
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
                selectedWall = apiManager.walls[index]
                
            }
            .onAppear {
                selectedWall = apiManager.walls[contentViewViewModel.wallIndex]
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

                    } label: {
                        Image(systemName: "heart")
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
                    
                } else {
                    // Fallback on earlier versions
                    Button {

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
                }

                //Download Button
                if #available(iOS 15.0, *) {
                    Button {

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
            .padding(.trailing, 24)
            .padding(.bottom, 18)
            .offset(y: -72)
        }
        .offset(y: contentViewViewModel.wallScreenViewOpened ? offset.height : offset.height < 0 ? -UIScreen.screenHeight : UIScreen.screenHeight)
        .animation(.interactiveSpring(), value: offset)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.bgColor)
        .opacity(contentViewViewModel.wallScreenViewOpened ? 1 : 0)
        .simultaneousGesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.width < 5 {
                        offset = gesture.translation
                    }
                }
                .onEnded { _ in
                    if abs(offset.height) > 100 {
                        contentViewViewModel.closeWallScreenView()
                        contentViewViewModel.openHomeView()
                        contentViewViewModel.openTopBar()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            apiManager.unloadWallScreenWalls()
                        }
                    } else {
                        offset = .zero
                    }
                }
        )
        .animation(.spring(), value: contentViewViewModel.wallScreenViewOpened)
    }
}
