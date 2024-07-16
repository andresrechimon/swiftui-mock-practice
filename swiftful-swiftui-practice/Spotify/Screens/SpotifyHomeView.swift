//
//  SpotifyHomeView.swift
//  swiftful-swiftui-practice
//
//  Created by Andres Rechimon on 26/05/2024.
//

import SwiftUI
import SwiftfulUI

struct SpotifyHomeView: View {
    @Environment(\.router) var router
    @State private var currentUser: User? = nil
    @State private var selectedCategory: Category? = nil
    @State private var users: [User] = []
    
    var body: some View {
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()
            ScrollView(.vertical) {
                LazyVStack(spacing: 10,
                           pinnedViews: [.sectionHeaders],
                           content: {
                    Section {
                        VStack(spacing: 16) {
                            recentSection
                            
                            if let user = currentUser {
                                newReleaseSection(user: user)
                            }
                            
                            listRows
                        }
                    } header: {
                        header
                    }
                    })
                .padding(.vertical, 8)
            }
            .scrollIndicators(.hidden)
            .clipped()
        }
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private func getData() async {
        do {
            currentUser = try await DatabaseHelper().getUsers().first
            users = try await Array(DatabaseHelper().getUsers().prefix(8))
        } catch {
            
        }
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            ZStack {
                if let currentUser {
                    ImageLoaderView(urlString: currentUser.image)
                        .background(Color.spotifyWhite)
                        .clipShape(Circle())
                        .onTapGesture {
                            router.dismissScreen()
                        }
                }
            }
            .frame(width: 35, height: 35)
            
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(Category.allCases, id: \.self) { category in
                        SpotifyCategoryCell(title: category.rawValue.capitalized, isSelected: category == selectedCategory)
                            .onTapGesture {
                                selectedCategory = category
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.vertical, 24)
        .padding(.leading, 8)
        .background(Color.spotifyBlack)
    }
    
    private var recentSection: some View {
        NonLazyVGrid(columns: 2, alignment: .center, spacing: 10, items: users) { user in
            if let user {
                SpotifyRecentCell(imageName: user.image, title: user.username)
                    .asButton(.press) {
                        goToPlaylistView(user: user)
                    }
            }
        }
    }
    
    private func goToPlaylistView(user: User) {
        router.showScreen(.push) { _ in
            SpotifyPlaylistView(user: user)
        }
    }
    
    private func newReleaseSection(user: User) -> some View {
        SpotifyNewReleaseCell(
            imageName: user.image,
            headline: user.firstName,
            subheadline: user.lastName,
            title: user.username,
            subtitle: user.email,
            onAddToPlaylistPressed: {
                goToPlaylistView(user: user)
            },
            onPlayPressed: {
                goToPlaylistView(user: user)
            }
        )
    }
    
    private var listRows: some View {
        VStack(spacing: 8) {
            Text("Trends")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.spotifyWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(users) { user in
                        ImageTitleRowCell(imageName: user.image, title: user.username)
                            .asButton(.press) {
                                goToPlaylistView(user: user)
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    SpotifyHomeView()
}
