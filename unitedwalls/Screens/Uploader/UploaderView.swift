//
//  UploaderView.swift
//  unitedwalls
//
//  Created by Paras KCD on 2023-07-14.
//

import SwiftUI
import SDWebImageSwiftUI

struct UploaderView: View {
    @EnvironmentObject var apiManager: ApiManager
    @EnvironmentObject var contentViewViewModel: ContentViewViewModel
    @EnvironmentObject var favouriteWallsStore: FavouriteWallsStore
    @State private var showingSheet = false
    @State private var saved: Bool = false
    @State var loading = false
    
    @State private var selection = 0
    
    var body: some View {
        ZStack {
            ScrollView {
                if apiManager.selectedUploader != nil {
                    ZStack(alignment: .bottom) {
                        WebImage(url: URL(string: apiManager.selectedUploader!.walls[0].file_url))
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
                        
                        if apiManager.selectedUploader!.avatar_file_url != nil {
                            VStack {
                                WebImage(url: URL(string: apiManager.selectedUploader!.avatar_file_url ?? ""))
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
                    Text("@\(apiManager.selectedUploader?.username ?? "")")
                        .font(.title).bold()
                }
                .padding(.horizontal, 15)
                HStack {
                    Text("\(apiManager.selectedUploader?.description ?? "")")
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 15)
                
                if apiManager.selectedUploader != nil {
                    if (apiManager.selectedUploader!.socialMediaLinks != nil && (apiManager.selectedUploader!.socialMediaLinks!.facebook != nil || apiManager.selectedUploader!.socialMediaLinks!.twitter != nil || apiManager.selectedUploader!.socialMediaLinks!.instagram != nil || apiManager.selectedUploader!.socialMediaLinks!.mastodon != nil || apiManager.selectedUploader!.socialMediaLinks!.steam != nil || apiManager.selectedUploader!.socialMediaLinks!.linkedIn != nil || apiManager.selectedUploader!.socialMediaLinks!.link != nil) && (apiManager.selectedUploader!.socialMediaLinks!.facebook != "" || apiManager.selectedUploader!.socialMediaLinks!.twitter != "" || apiManager.selectedUploader!.socialMediaLinks!.instagram != "" || apiManager.selectedUploader!.socialMediaLinks!.mastodon != "" || apiManager.selectedUploader!.socialMediaLinks!.steam != "" || apiManager.selectedUploader!.socialMediaLinks!.linkedIn != "" || apiManager.selectedUploader!.socialMediaLinks!.link != "" || apiManager.selectedUploader!.socialMediaLinks!.other!.count > 0)) || (apiManager.selectedUploader!.donationLinks != nil && (apiManager.selectedUploader!.donationLinks!.patreon != nil || apiManager.selectedUploader!.donationLinks!.paypal != nil) && (apiManager.selectedUploader!.donationLinks!.patreon != "" || apiManager.selectedUploader!.donationLinks!.paypal != "" || apiManager.selectedUploader!.donationLinks!.otherdonations!.count > 0)) {
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
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(Array(apiManager.selectedUploader!.walls.enumerated()), id: \.element._id) { index, wall in
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
                                .onAppear {
                                    if index == 0 || index % 8 == 0 {
                                        SDImageCache.shared.clearMemory()
                                    }
                                    if apiManager.selectedUploader!.walls.count != apiManager.uploaderWallsTotalCount {
                                        if index == apiManager.selectedUploader!.walls.count - 5 {
                                            apiManager.loadUploaderById(userId: apiManager.selectedUploader!._id, initialize: false)
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
                                .sheet(isPresented: $showingSheet, onDismiss: {
                                    contentViewViewModel.changeWallIndex(index: 0)
                                    contentViewViewModel.changeOpacity(opacity: 0)
                                }) {
                                    UploaderWallScreenView()
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
                            if apiManager.selectedUploader!.donationLinks != nil && (apiManager.selectedUploader!.donationLinks!.patreon != nil || apiManager.selectedUploader!.donationLinks!.paypal != nil) && (apiManager.selectedUploader!.donationLinks!.patreon != "" || apiManager.selectedUploader!.donationLinks!.paypal != "" || apiManager.selectedUploader!.donationLinks!.otherdonations!.count > 0) {
                                
                                HStack {
                                    Text("Donation Links")
                                        .font(.title2).bold()
                                    Spacer()
                                }
                                
                                
                                LazyVStack(alignment: .leading) {
                                    if apiManager.selectedUploader!.donationLinks!.patreon != nil && apiManager.selectedUploader!.donationLinks!.patreon != "" {
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
                                            UIApplication.shared.open(URL(string: apiManager.selectedUploader!.donationLinks!.patreon ?? "")!)
                                        }
                                    }
                                    if apiManager.selectedUploader!.donationLinks!.paypal != nil && apiManager.selectedUploader!.donationLinks!.paypal != "" {
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
                                            UIApplication.shared.open(URL(string: apiManager.selectedUploader!.donationLinks!.paypal ?? "")!)
                                        }
                                    }
                                    
                                    if apiManager.selectedUploader!.donationLinks!.otherdonations != nil && apiManager.selectedUploader!.donationLinks!.otherdonations!.count > 0 {
                                        ForEach(apiManager.selectedUploader!.donationLinks!.otherdonations!, id:\.title) { otherLink in
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
                            
                            if apiManager.selectedUploader!.socialMediaLinks != nil && (apiManager.selectedUploader!.socialMediaLinks!.facebook != nil || apiManager.selectedUploader!.socialMediaLinks!.twitter != nil || apiManager.selectedUploader!.socialMediaLinks!.instagram != nil || apiManager.selectedUploader!.socialMediaLinks!.mastodon != nil || apiManager.selectedUploader!.socialMediaLinks!.steam != nil || apiManager.selectedUploader!.socialMediaLinks!.linkedIn != nil || apiManager.selectedUploader!.socialMediaLinks!.link != nil) && (apiManager.selectedUploader!.socialMediaLinks!.facebook != "" || apiManager.selectedUploader!.socialMediaLinks!.twitter != "" || apiManager.selectedUploader!.socialMediaLinks!.instagram != "" || apiManager.selectedUploader!.socialMediaLinks!.mastodon != "" || apiManager.selectedUploader!.socialMediaLinks!.steam != "" || apiManager.selectedUploader!.socialMediaLinks!.linkedIn != "" || apiManager.selectedUploader!.socialMediaLinks!.link != "" || apiManager.selectedUploader!.socialMediaLinks!.other!.count > 0) {
                                HStack {
                                    Text("Social Links")
                                        .font(.title2).bold()
                                    Spacer()
                                }
                                
                                
                                LazyVStack(alignment: .leading) {
                                    if apiManager.selectedUploader!.socialMediaLinks!.facebook != nil && apiManager.selectedUploader!.socialMediaLinks!.facebook != "" {
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
                                            UIApplication.shared.open(URL(string: apiManager.selectedUploader!.socialMediaLinks!.facebook ?? "")!)
                                        }
                                    }
                                    if apiManager.selectedUploader!.socialMediaLinks!.twitter != nil && apiManager.selectedUploader!.socialMediaLinks!.twitter != "" {
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
                                            UIApplication.shared.open(URL(string: apiManager.selectedUploader!.socialMediaLinks!.twitter ?? "")!)
                                        }
                                    }
                                    if apiManager.selectedUploader!.socialMediaLinks!.instagram != nil && apiManager.selectedUploader!.socialMediaLinks!.instagram != "" {
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
                                            UIApplication.shared.open(URL(string: apiManager.selectedUploader!.socialMediaLinks!.instagram ?? "")!)
                                        }
                                    }
                                    if apiManager.selectedUploader!.socialMediaLinks!.mastodon != nil && apiManager.selectedUploader!.socialMediaLinks!.mastodon != "" {
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
                                            UIApplication.shared.open(URL(string: apiManager.selectedUploader!.socialMediaLinks!.mastodon ?? "")!)
                                        }
                                    }
                                    if apiManager.selectedUploader!.socialMediaLinks!.steam != nil && apiManager.selectedUploader!.socialMediaLinks!.steam != "" {
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
                                            UIApplication.shared.open(URL(string: apiManager.selectedUploader!.socialMediaLinks!.steam ?? "")!)
                                        }
                                    }
                                    if apiManager.selectedUploader!.socialMediaLinks!.linkedIn != nil && apiManager.selectedUploader!.socialMediaLinks!.linkedIn != "" {
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
                                            UIApplication.shared.open(URL(string: apiManager.selectedUploader!.socialMediaLinks!.linkedIn ?? "")!)
                                        }
                                    }
                                    if apiManager.selectedUploader!.socialMediaLinks!.link != nil && apiManager.selectedUploader!.socialMediaLinks!.link != "" {
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
                                            UIApplication.shared.open(URL(string: apiManager.selectedUploader!.socialMediaLinks!.link ?? "")!)
                                        }
                                    }
                                    if apiManager.selectedUploader!.socialMediaLinks!.other != nil && apiManager.selectedUploader!.socialMediaLinks!.other!.count > 0 {
                                        ForEach(apiManager.selectedUploader!.socialMediaLinks!.other!, id:\.title) { otherLink in
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
            
            VStack(alignment: .center) {
                Text("Wallpaper saved in the Photos App").padding(12).background(Color.theme.bgTertiaryColor).cornerRadius(100).frame(width: 300, height: 30).shadow(radius: 20, x: 3, y: 12).frame(maxWidth: .infinity, maxHeight: UIScreen.screenHeight).offset(y: saved ?  -(UIScreen.screenHeight - 580) : -(UIScreen.screenHeight - 440)).opacity(saved ? 1 : 0).animation(.spring(), value: saved)
            }
            
            Color.black.opacity(loading ? 0.75 : 0)
            
            if loading {
                VStack {
                    ProgressView()
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: UIScreen.screenWidth - 5, maxHeight: .infinity)
        .offset(x: contentViewViewModel.uploaderViewOpened ? 18 : -UIScreen.screenWidth)
        .opacity(contentViewViewModel.uploaderViewOpened ? 1 : 0)
        .animation(.spring(), value: contentViewViewModel.uploaderViewOpened)
    }
}
