//
//  Drawer.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-03-08.
//

import SwiftUI

struct Drawer: View {
    var opened: Bool = false
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    @EnvironmentObject var favouriteWallsStore: FavouriteWallsStore
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Spacer()
                .frame(height: 60)
            Image(colorScheme == .dark ? "DrawerImageDark" : "DrawerImageLight")
                .resizable()
                .scaledToFit()
            DrawerItem(
                icon: "house.fill",
                name: "Home",
                active: contentViewViewModel.homeViewOpened,
                onClick: {
                    DispatchQueue.main.async {
                        contentViewViewModel.openHomeView()
                        contentViewViewModel.closeSidebar()
                        if contentViewViewModel.aboutViewOpened {
                            contentViewViewModel.closeAboutView()
                        }
                        if contentViewViewModel.categoriesViewOpened {
                            contentViewViewModel.closeCategoriesView()
                        }
                        if contentViewViewModel.favouriteWallsViewOpened {
                            contentViewViewModel.closeFavouriteWalls()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                apiManager.unloadFavouriteWalls()
                            }
                        }
                        if contentViewViewModel.categoryViewOpened {
                            contentViewViewModel.closeCategoryView()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                apiManager.unloadCategory()
                            }
                        }
                    }
                }
            )
            if favouriteWallsStore.walls.count > 0 {
                DrawerItem(
                    icon: "heart.fill",
                    name: "Favourites",
                    active: contentViewViewModel.favouriteWallsViewOpened,
                    onClick: {
                        DispatchQueue.main.async {
                            apiManager.loadFavouriteWalls(wallIds: favouriteWallsStore.walls)
                            contentViewViewModel.closeSidebar()
                            if contentViewViewModel.homeViewOpened {
                                contentViewViewModel.closeHomeView()
                            }
                            if contentViewViewModel.aboutViewOpened {
                                contentViewViewModel.closeAboutView()
                            }
                            if contentViewViewModel.categoriesViewOpened {
                                contentViewViewModel.closeCategoriesView()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                contentViewViewModel.openFavouriteWalls()
                            }
                            if contentViewViewModel.categoryViewOpened {
                                contentViewViewModel.closeCategoryView()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    apiManager.unloadCategory()
                                }
                            }
                        }
                    }
                )
            }
            DrawerItem(
                icon: "info.circle.fill",
                name: "About",
                active: contentViewViewModel.aboutViewOpened,
                onClick: {
                    DispatchQueue.main.async {
                        contentViewViewModel.openAboutView()
                        contentViewViewModel.closeSidebar()
                        if contentViewViewModel.homeViewOpened {
                            contentViewViewModel.closeHomeView()
                        }
                        if contentViewViewModel.categoriesViewOpened {
                            contentViewViewModel.closeCategoriesView()
                        }
                        if contentViewViewModel.favouriteWallsViewOpened {
                            contentViewViewModel.closeFavouriteWalls()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                apiManager.unloadFavouriteWalls()
                            }
                        }
                        if contentViewViewModel.categoryViewOpened {
                            contentViewViewModel.closeCategoryView()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                apiManager.unloadCategory()
                            }
                        }
                    }
                }
            )
            DrawerItem(
                icon: "filemenu.and.selection",
                name: "Categories",
                active: contentViewViewModel.categoriesViewOpened || contentViewViewModel.categoryViewOpened,
                onClick: {
                    DispatchQueue.main.async {
                        contentViewViewModel.openCategoriesView()
                        contentViewViewModel.closeSidebar()
                        if contentViewViewModel.homeViewOpened {
                            contentViewViewModel.closeHomeView()
                        }
                        if contentViewViewModel.aboutViewOpened {
                            contentViewViewModel.closeAboutView()
                        }
                        if contentViewViewModel.favouriteWallsViewOpened {
                            contentViewViewModel.closeFavouriteWalls()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                apiManager.unloadFavouriteWalls()
                            }
                        }
                        if contentViewViewModel.categoryViewOpened {
                            contentViewViewModel.closeCategoryView()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                apiManager.unloadCategory()
                            }
                        }
                    }
                }
            )
            if apiManager.loadingCategories {
                ProgressView()
                    .padding()
            } else {
                LazyVStack {
                    ForEach(apiManager.categories, id: \._id) { category in
                        Button {
                            DispatchQueue.main.async {
                                if contentViewViewModel.categoryViewOpened {
                                    contentViewViewModel.closeCategoryView()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        apiManager.unloadCategory()
                                    }
                                }
                                contentViewViewModel.closeSidebar()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    apiManager.loadCategory(category: category)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                    contentViewViewModel.openCategoryView()
                                }
                                if contentViewViewModel.homeViewOpened {
                                    contentViewViewModel.closeHomeView()
                                }
                                if contentViewViewModel.aboutViewOpened {
                                    contentViewViewModel.closeAboutView()
                                }
                                if contentViewViewModel.categoriesViewOpened {
                                    contentViewViewModel.closeCategoriesView()
                                }
                                if contentViewViewModel.favouriteWallsViewOpened {
                                    contentViewViewModel.closeFavouriteWalls()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        apiManager.unloadFavouriteWalls()
                                    }
                                }
                            }
                        } label: {
                            Text(category.name)
                                .fontWeight(.light)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 36)
                                .padding(12)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 12)
                .background(Color.theme.bgTertiaryColor)
                .cornerRadius(36, corners: [.topLeft, .topRight, .bottomLeft])
                .padding([.leading], 16)
            }
        }
        .frame(minWidth: 0, maxWidth: 234, minHeight: 0, maxHeight: .infinity)
        .background(Color.theme.bgColor)
        .offset(x: opened ? 0 : -UIScreen.screenWidth + contentViewViewModel.sidebarOffset)
        .animation(.spring().speed(1.5), value: opened)
    }
}

struct DrawerItem: View {
    var icon: String
    var name: String
    var active: Bool
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text(name)
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 18)
            .padding(12)
            .background(active ? Color.theme.bgTertiaryColor : .clear)
            .cornerRadius(36)
            .padding(.leading, 18)
        }
        .buttonStyle(DrawerButtonStyle())
    }
}

struct DrawerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .background(configuration.isPressed ? Color.theme.bgTertiaryColor : .clear)
            .cornerRadius(36)
            .animation(.easeOut, value: configuration.isPressed)
            .padding(.horizontal, 12)
    }
}
