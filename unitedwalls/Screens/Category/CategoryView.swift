//
//  CategoryView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-13.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    @State private var showingSheet = false
    
    var body: some View {
        ZStack {
            ScrollView {
                Spacer()
                    .frame(height: 120)
                
                HStack {
                    Text(apiManager.selectedCategory?.name ?? "Category")
                        .font(.title2)
                    Spacer()
                }
                .padding(.horizontal, 15)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 5) {
                    if apiManager.selectedCategory != nil {
                        ForEach(Array(apiManager.selectedCategory!.walls.enumerated()), id:\.element._id) { index, wall in
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
                            .gesture(DragGesture(minimumDistance: 0).onChanged({ _ in
                                //do nothing
                            }))
                            .onAppear {
                                if index == 0 || index % 8 == 0 {
                                    SDImageCache.shared.clearMemory()
                                }
                                if apiManager.selectedCategory!.walls.count != apiManager.categoryWallsTotalCount {
                                    if index == apiManager.selectedCategory!.walls.count - 5 {
                                        apiManager.loadCategoryById(categoryId: apiManager.selectedCategory!._id, initialize: false)
                                        SDImageCache.shared.clearMemory()
                                    }
                                }
                            }
                            .sheet(isPresented: $showingSheet, onDismiss: {
                                contentViewViewModel.changeWallIndex(index: 0)
                                contentViewViewModel.changeOpacity(opacity: 0)
                            }) {
                                CategoryWallScreenView()
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
            .offset(x: contentViewViewModel.categoryViewOpened ? 18 : -UIScreen.screenWidth)
            .opacity(contentViewViewModel.categoryViewOpened ? 1 : 0)
            .animation(.spring(), value: contentViewViewModel.categoryViewOpened)
        }
        
    }
}
