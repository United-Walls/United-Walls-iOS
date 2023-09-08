//
//  UploaderNavWallScreenView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-08-11.
//

import SwiftUI
import SDWebImageSwiftUI

struct UploaderNavWallScreenView: View {
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
                if selectedUploaderID != nil {
                    let selectedUploader: Uploader? = apiManager.uploaders.filter { uploader in uploader._id == selectedUploaderID }[0]
                    
                    if selectedUploader != nil {
                        ZStack(alignment: .bottom) {
                            WebImage(url: URL(string: selectedUploader!.walls[0].file_url))
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
                            
                            if selectedUploader!.avatar_file_url != nil {
                                VStack {
                                    WebImage(url: URL(string: selectedUploader!.avatar_file_url ?? ""))
                                        .purgeable(true)
                                        .resizable()
                                        .indicator(.activity)
                                        .transition(.fade(duration: 0.5))
                                        .scaledToFill()
                                        .frame(width: 180, height: 180)
                                        .background(Color.theme.bgTertiaryColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 18))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 18)
                                                .stroke(Color.theme.bgColor, lineWidth: 8)
                                        )
                                        .shadow(radius: 10)
                                }
                                .offset(y: 80)
                            }
                        }
                        .frame(height: 320)
                        
                        Spacer()
                            .frame(height: 100)
                    } else {
                        Spacer()
                            .frame(height: 120)
                    }
                    
                    HStack {
                        Text("@\(selectedUploader?.username ?? "")")
                            .font(.title).bold()
                    }
                    .padding(.horizontal, 15)
                    HStack {
                        Text("\(selectedUploader?.description ?? "")")
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 15)
                    
                    if selectedUploader != nil {
                        if (selectedUploader!.socialMediaLinks != nil && (selectedUploader!.socialMediaLinks!.facebook != nil || selectedUploader!.socialMediaLinks!.twitter != nil || selectedUploader!.socialMediaLinks!.instagram != nil || selectedUploader!.socialMediaLinks!.mastodon != nil || selectedUploader!.socialMediaLinks!.steam != nil || selectedUploader!.socialMediaLinks!.linkedIn != nil || selectedUploader!.socialMediaLinks!.link != nil) && (selectedUploader!.socialMediaLinks!.facebook != "" || selectedUploader!.socialMediaLinks!.twitter != "" || selectedUploader!.socialMediaLinks!.instagram != "" || selectedUploader!.socialMediaLinks!.mastodon != "" || selectedUploader!.socialMediaLinks!.steam != "" || selectedUploader!.socialMediaLinks!.linkedIn != "" || selectedUploader!.socialMediaLinks!.link != "" || selectedUploader!.socialMediaLinks!.other!.count > 0)) || (selectedUploader!.donationLinks != nil && (selectedUploader!.donationLinks!.patreon != nil || selectedUploader!.donationLinks!.paypal != nil) && (selectedUploader!.donationLinks!.patreon != "" || selectedUploader!.donationLinks!.paypal != "" || selectedUploader!.donationLinks!.otherdonations!.count > 0)) {
                            Picker("Page", selection: $selection) {
                                Text("Walls").tag(0)
                                Text("Info").tag(1)
                            }
                            .pickerStyle(.segmented)
                            .onTapGesture {
                                if self.selection == 0 {
                                    self.selection = 1
                                } else {
                                    self.selection = 0
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 20)
                        }
                        
                        if (selection == 0) {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 5) {
                                ForEach(Array(selectedUploader!.walls.enumerated()), id: \.element._id) { index, wall in
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
                                        .onAppear {
                                            if index == 0 || index % 8 == 0 {
                                                SDImageCache.shared.clearMemory()
                                            }
                                            if selectedUploader!.walls.count != apiManager.uploaderWallsTotalCount {
                                                if index == selectedUploader!.walls.count - 5 {
                                                    apiManager.loadUploaderById(userId: selectedUploader!._id, initialize: false)
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
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: 90)
                                Spacer()
                                    .frame(height: 90)
                            }
                        }
                        
                        if (selection == 1) {
                            LazyVStack(alignment: .leading) {
                                if selectedUploader!.donationLinks != nil && (selectedUploader!.donationLinks!.patreon != nil || selectedUploader!.donationLinks!.paypal != nil) && (selectedUploader!.donationLinks!.patreon != "" || selectedUploader!.donationLinks!.paypal != "" || selectedUploader!.donationLinks!.otherdonations!.count > 0) {
                                    
                                    HStack {
                                        Text("Donation Links")
                                            .font(.title2).bold()
                                        Spacer()
                                    }
                                    
                                    
                                    LazyVStack(alignment: .leading) {
                                        if selectedUploader!.donationLinks!.patreon != nil && selectedUploader!.donationLinks!.patreon != "" {
                                            HStack {
                                                Image("patreon")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 25)
                                                    .foregroundColor(Color.theme.textColor)
                                                Text("Patreon")
                                            }
                                            .onTapGesture {
                                                UIApplication.shared.open(URL(string: selectedUploader!.donationLinks!.patreon ?? "")!)
                                            }
                                        }
                                        if selectedUploader!.donationLinks!.paypal != nil && selectedUploader!.donationLinks!.paypal != "" {
                                            HStack {
                                                Image("paypal")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 25)
                                                    .foregroundColor(Color.theme.textColor)
                                                Text("Paypal")
                                            }
                                            .onTapGesture {
                                                UIApplication.shared.open(URL(string: selectedUploader!.donationLinks!.paypal ?? "")!)
                                            }
                                        }
                                        
                                        if selectedUploader!.donationLinks!.otherdonations != nil && selectedUploader!.donationLinks!.otherdonations!.count > 0 {
                                            ForEach(selectedUploader!.donationLinks!.otherdonations!, id:\.title) { otherLink in
                                                if otherLink.link != nil && otherLink.link != "" {
                                                    HStack {
                                                        Image(systemName: "link")
                                                            .renderingMode(.template)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 25)
                                                            .foregroundColor(Color.theme.textColor)
                                                        Text(otherLink.title ?? "")
                                                    }
                                                    .onTapGesture {
                                                        UIApplication.shared.open(URL(string: otherLink.link ?? "")!)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(18)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .background(Color.theme.bgColor)
                                    .cornerRadius(18)
                                    .shadow(radius: 20, x: 3, y: 12)
                                    
                                    Spacer()
                                        .frame(height: 10)
                                }
                                
                                if selectedUploader!.socialMediaLinks != nil && (selectedUploader!.socialMediaLinks!.facebook != nil || selectedUploader!.socialMediaLinks!.twitter != nil || selectedUploader!.socialMediaLinks!.instagram != nil || selectedUploader!.socialMediaLinks!.mastodon != nil || selectedUploader!.socialMediaLinks!.steam != nil || selectedUploader!.socialMediaLinks!.linkedIn != nil || selectedUploader!.socialMediaLinks!.link != nil) && (selectedUploader!.socialMediaLinks!.facebook != "" || selectedUploader!.socialMediaLinks!.twitter != "" || selectedUploader!.socialMediaLinks!.instagram != "" || selectedUploader!.socialMediaLinks!.mastodon != "" || selectedUploader!.socialMediaLinks!.steam != "" || selectedUploader!.socialMediaLinks!.linkedIn != "" || selectedUploader!.socialMediaLinks!.link != "" || selectedUploader!.socialMediaLinks!.other!.count > 0) {
                                    HStack {
                                        Text("Social Links")
                                            .font(.title2).bold()
                                        Spacer()
                                    }
                                    
                                    
                                    LazyVStack(alignment: .leading) {
                                        if selectedUploader!.socialMediaLinks!.facebook != nil && selectedUploader!.socialMediaLinks!.facebook != "" {
                                            HStack {
                                                Image("facebook")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 25)
                                                    .foregroundColor(Color.theme.textColor)
                                                Text("Facebook")
                                            }
                                            .onTapGesture {
                                                UIApplication.shared.open(URL(string: selectedUploader!.socialMediaLinks!.facebook ?? "")!)
                                            }
                                        }
                                        if selectedUploader!.socialMediaLinks!.twitter != nil && selectedUploader!.socialMediaLinks!.twitter != "" {
                                            HStack {
                                                Image("x-twitter")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 25)
                                                    .foregroundColor(Color.theme.textColor)
                                                Text("𝕏")
                                            }
                                            .onTapGesture {
                                                UIApplication.shared.open(URL(string: selectedUploader!.socialMediaLinks!.twitter ?? "")!)
                                            }
                                        }
                                        if selectedUploader!.socialMediaLinks!.instagram != nil && selectedUploader!.socialMediaLinks!.instagram != "" {
                                            HStack {
                                                Image("instagram")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 25)
                                                    .foregroundColor(Color.theme.textColor)
                                                Text("Instagram")
                                            }
                                            .onTapGesture {
                                                UIApplication.shared.open(URL(string: selectedUploader!.socialMediaLinks!.instagram ?? "")!)
                                            }
                                        }
                                        if selectedUploader!.socialMediaLinks!.mastodon != nil && selectedUploader!.socialMediaLinks!.mastodon != "" {
                                            HStack {
                                                Image("mastodon")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 25)
                                                    .foregroundColor(Color.theme.textColor)
                                                Text("Mastodon")
                                            }
                                            .onTapGesture {
                                                UIApplication.shared.open(URL(string: selectedUploader!.socialMediaLinks!.mastodon ?? "")!)
                                            }
                                        }
                                        if selectedUploader!.socialMediaLinks!.steam != nil && selectedUploader!.socialMediaLinks!.steam != "" {
                                            HStack {
                                                Image("steam")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 25)
                                                    .foregroundColor(Color.theme.textColor)
                                                Text("Steam")
                                            }
                                            .onTapGesture {
                                                UIApplication.shared.open(URL(string: selectedUploader!.socialMediaLinks!.steam ?? "")!)
                                            }
                                        }
                                        if selectedUploader!.socialMediaLinks!.linkedIn != nil && selectedUploader!.socialMediaLinks!.linkedIn != "" {
                                            HStack {
                                                Image("linkedin")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 25)
                                                    .foregroundColor(Color.theme.textColor)
                                                Text("LinkedIn")
                                            }
                                            .onTapGesture {
                                                UIApplication.shared.open(URL(string: selectedUploader!.socialMediaLinks!.linkedIn ?? "")!)
                                            }
                                        }
                                        if selectedUploader!.socialMediaLinks!.link != nil && selectedUploader!.socialMediaLinks!.link != "" {
                                            HStack {
                                                Image(systemName: "link")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 25)
                                                    .foregroundColor(Color.theme.textColor)
                                                Text("Link")
                                            }
                                            .onTapGesture {
                                                UIApplication.shared.open(URL(string: selectedUploader!.socialMediaLinks!.link ?? "")!)
                                            }
                                        }
                                        if selectedUploader!.socialMediaLinks!.other != nil && selectedUploader!.socialMediaLinks!.other!.count > 0 {
                                            ForEach(selectedUploader!.socialMediaLinks!.other!, id:\.title) { otherLink in
                                                if otherLink.link != nil && otherLink.link != "" {
                                                    HStack {
                                                        Image(systemName: "link")
                                                            .renderingMode(.template)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 25)
                                                            .foregroundColor(Color.theme.textColor)
                                                        Text(otherLink.title ?? "")
                                                    }
                                                    .onTapGesture {
                                                        UIApplication.shared.open(URL(string: otherLink.link ?? "")!)
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                    .padding(18)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .background(Color.theme.bgColor)
                                    .cornerRadius(18)
                                    .shadow(radius: 20, x: 3, y: 12)
                                }
                                Spacer()
                                    .frame(height: 90)
                            }
                            .padding(.horizontal)
                                
                        }
                        
                    }
                }
            }
            Rectangle().foregroundColor(Color.clear).frame(height: 150).background(LinearGradient(gradient: Gradient(colors: [Color.theme.bgColor, Color.theme.bgColor.opacity(0.8), .clear]), startPoint: .top, endPoint: .bottom))
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.bgTertiaryColor.ignoresSafeArea(.all))
        .foregroundColor(Color.theme.textColor)
    }
}
