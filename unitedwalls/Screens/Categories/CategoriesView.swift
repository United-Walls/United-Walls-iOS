//
//  CategoriesView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-13.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoriesView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                Spacer()
                    .frame(height: 120)
                Spacer()
                    .frame(height: 120)
                ForEach(Array(apiManager.categories.enumerated()), id: \.element._id) { index, category in
                    if category.walls.count > 0 {
                        Button {
                            DispatchQueue.main.async {
                                contentViewViewModel.closeCategoriesView()
                                apiManager.loadCategoryById(categoryId: category._id, initialize: true)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    contentViewViewModel.openCategoryView()
                                }
                            }
                        } label: {
                            ZStack(alignment: .center) {
                                WebImage(url: URL(string: category.walls[0].thumbnail_url))
                                    .resizable()
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.5))
                                    .scaledToFill()
                                    .frame(width: 170, height: 100, alignment: .center)
                                    .background(Color.theme.bgTertiaryColor)
                                    .cornerRadius(18)
                                
                                Color.theme.bgTertiaryColor.opacity(0.2)
                                
                                if #available(iOS 15.0, *) {
                                    Text(category.name)
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(18)
                                } else {
                                    Text(category.name)
                                        .padding()
                                        .background(Color.theme.bgTertiaryColor.opacity(0.5))
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
        .offset(x: contentViewViewModel.categoriesViewOpened ? 18 : -UIScreen.screenWidth)
        .opacity(contentViewViewModel.categoriesViewOpened ? 1 : 0)
        .animation(.spring(), value: contentViewViewModel.categoriesViewOpened)
    }
}
