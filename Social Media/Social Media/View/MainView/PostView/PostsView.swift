//
//  PostsView.swift
//  Social Media
//
//  Created by TrungAnhx on 16/11/25.
//

import SwiftUI

struct PostsView: View {
    @State private var recentsPosts: [Post] = []
    @State private var createNewPost: Bool = false
    var body: some View {
        NavigationStack {
            ReusablePostsView(posts: $recentsPosts)
                .hAlign(.center).vAlign(.center)
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        createNewPost.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(13)
                            .background(.black, in: Circle())
                    }
                    .padding(15)
                }
                .toolbar(content: {
                    NavigationLink {
                            SearchUserView()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .tint(.black)
                            .scaleEffect(0.9)
                    }
                })
                .navigationTitle("Posts")
        }
        .fullScreenCover(isPresented: $createNewPost) {
            CreateNewPost { post in
                // Adding created post at the top of the recent post
                recentsPosts.insert(post, at: 0)
            }
        }
    }
}

#Preview {
    PostsView()
}
