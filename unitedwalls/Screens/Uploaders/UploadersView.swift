//
//  UploadersView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-07-14.
//

import SwiftUI
import SDWebImageSwiftUI

struct UploadersView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                Spacer()
                    .frame(height: 120)
                Spacer()
                    .frame(height: 120)
                
                ForEach(Array(apiManager.uploaders.enumerated()), id: \.element._id) { index, uploader in
                    if uploader.walls.count > 0 {
                        Button {
                            DispatchQueue.main.async {
                                contentViewViewModel.closeUploadersScreenView()
                                apiManager.loadUploaderById(userId: uploader._id, initialize: true)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    contentViewViewModel.openUploaderScreenView()
                                }
                            }
                        } label: {
                            ZStack(alignment: .center) {
                                WebImage(url: URL(string: uploader.walls[0].thumbnail_url))
                                    .resizable()
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.5))
                                    .scaledToFill()
                                    .frame(width: 170, height: 100, alignment: .center)
                                    .background(Color.theme.bgTertiaryColor)
                                    .cornerRadius(18)
                                
                                Color.theme.bgTertiaryColor.opacity(0.2)
                                
                                if uploader.avatar_file_url != nil {
                                    HStack(alignment: .center, spacing: 8) {
                                        WebImage(url: URL(string: uploader.avatar_file_url!))
                                            .resizable()
                                            .indicator(.activity)
                                            .transition(.fade(duration: 0.5))
                                            .scaledToFill()
                                            .frame(width: 32, height: 32)
                                            .background(Color.theme.bgTertiaryColor)
                                            .clipShape(Circle())
                                        
                                        Text(uploader.username)
                                            .lineLimit(1)
                                            .padding()
                                            .background(.ultraThinMaterial)
                                            .cornerRadius(18)
                                            .frame(width: 100, alignment: Alignment.leading)
                                    }
                                } else {
                                    Text(uploader.username)
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(18)
                                }
                            }
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
                
                Spacer()
                    .frame(height: 80)
                Spacer()
                    .frame(height: 80)
            }
        }
        .frame(maxWidth: UIScreen.screenWidth - 5, maxHeight: .infinity)
        .offset(x: contentViewViewModel.uploadersViewOpened ? 18 : -UIScreen.screenWidth)
        .opacity(contentViewViewModel.uploadersViewOpened ? 1 : 0)
        .animation(.spring(), value: contentViewViewModel.uploadersViewOpened)
    }
}
