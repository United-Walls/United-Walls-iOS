//
//  CategoryNavWallScreenView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-08-11.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryNavWallScreenView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var favouriteWallsStore: FavouriteWallsStore
    
    @State var selectedCategoryId: String?
    @State var selectedUploaderID: String?
    @State private var selection = 0
    @State private var saved: Bool = false
    @State var loading = false
    @State private var action: Int? = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                if selectedCategoryId != nil {
                    let selectedCategory: Category? = apiManager.categories.filter { category in category._id == selectedCategoryId}[0]
                    
                    if selectedCategory != nil {
                        Spacer()
                            .frame(height: 60)
                        
                        HStack {
                            Text(selectedCategory?.name ?? "Category")
                                .font(.title2)
                            Spacer()
                        }
                        .padding(.horizontal, 15)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            
                            ForEach(Array(selectedCategory!.walls.enumerated()), id:\.element._id) { index, wall in
                                let addedBy: String? = apiManager.uploaders.filter { uploader in uploader._id == wall.creator }[0].username
                                let categoryName: String? = apiManager.categories.filter { category in category._id == wall.category }[0].name
                                
                                VStack {
                                    NavigationLink(destination: NavWallNavWallScreenView(selectedWall: wall, addedBy: addedBy ?? "", categoryName: categoryName ?? ""), tag: index+1, selection: $action) {
                                        EmptyView()
                                    }
                                    Button {
                                        self.action = index+1
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
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            Rectangle().foregroundColor(Color.clear).frame(height: 100).background(LinearGradient(gradient: Gradient(colors: [Color.theme.bgColor, Color.theme.bgColor.opacity(0.8), .clear]), startPoint: .top, endPoint: .bottom))
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.bgTertiaryColor.ignoresSafeArea(.all))
        .foregroundColor(Color.theme.textColor)
    }
}
