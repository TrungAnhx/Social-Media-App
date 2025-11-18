//
//  PostCardView.swift
//  Social Media
//
//  Created by TrungAnhx on 18/11/25.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct PostCardView: View {
    var post: Post
    
    // Callbacks
    var onUpdate: (Post) -> ()
    var onDelete: () -> ()
    
    // View Properties
    @AppStorage("user_UID") private var userUID: String = ""
    @State private var docListener: ListenerRegistration?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            WebImage(url: post.userProfileURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(post.userName)
                    .font(.callout)
                    .fontWeight(.semibold)
                Text(post.publishedDate.formatted(date: .numeric, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.gray)
                Text(post.text)
                    .textSelection(.enabled)
                    .padding(.vertical, 8)
                
                // Post image if any
                if let postImageURL = post.imageURL {
                    GeometryReader {
                        let size = $0.size
                        WebImage(url: postImageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .frame(height: 200)
                }
                
                PostInteraction()
            }
        }
        .hAlign(.leading)
        .overlay(alignment: .topTrailing, content: {
            // Displaying delete button (if it's author of that post)
            if post.userUID == userUID {
                Menu {
                    Button("Delete Post", role: .destructive, action: deletePost)
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.caption)
                        .rotationEffect(.init(degrees: -90))
                        .foregroundStyle(.black)
                        .padding(8)
                        .contentShape(Rectangle())
                }
                .offset(x: 8)
            }
            
        })
        .onAppear {
            if docListener == nil {
                guard let postID = post.id else { return }
                docListener = Firestore.firestore()
                    .collection("Posts")
                    .document(postID)
                    .addSnapshotListener({ snapshot, error in
                        if let snapshot {
                            if snapshot.exists {
                                if let updatedPost = try? snapshot.data(as: Post.self) {
                                    onUpdate(updatedPost)
                                }
                            } else {
                                onDelete()
                            }
                        }
                    })
            }
        }
        .onDisappear {
            if let docListener {
                docListener.remove()
                self.docListener = nil
            }
        }
    }
    
    // MARK: Like/Dislike interaction
    @ViewBuilder
    func PostInteraction() -> some View {
        HStack(spacing: 6) {
            Button(action: likePost) {
                Image(systemName: post.likedIDs.contains(userUID) ? "hand.thumbsup.fill" : "hand.thumbsup")
            }
            
            Text("\(post.likedIDs.count)")
                .font(.caption)
                .foregroundStyle(.gray)
            
            Button(action: dislikePost) {
                Image(systemName: post.dislikedIDs.contains(userUID) ? "hand.thumbsdown.fill" : "hand.thumbsdown")
            }
            .padding(.leading, 25)
            
            Text("\(post.dislikedIDs.count)")
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .foregroundStyle(.black)
        .padding(.vertical, 8)
    }
    
    // Like post
    func likePost() {
        Task {
            guard let postID = post.id else { return }
            if post.likedIDs.contains(userUID) {
                try await Firestore.firestore()
                    .collection("Posts")
                    .document(postID)
                    .updateData(["likedIDs": FieldValue.arrayRemove([userUID])])
            } else {
                try await Firestore.firestore()
                    .collection("Posts")
                    .document(postID)
                    .updateData([
                        "likedIDs": FieldValue.arrayUnion([userUID]),
                        "dislikedIDs": FieldValue.arrayRemove([userUID])
                    ])
            }
        }
    }
    
    // Dislike post
    func dislikePost() {
        Task {
            guard let postID = post.id else { return }
            if post.dislikedIDs.contains(userUID) {
                try await Firestore.firestore()
                    .collection("Posts")
                    .document(postID)
                    .updateData(["dislikedIDs": FieldValue.arrayRemove([userUID])])
            } else {
                try await Firestore.firestore()
                    .collection("Posts")
                    .document(postID)
                    .updateData([
                        "likedIDs": FieldValue.arrayRemove([userUID]),
                        "dislikedIDs": FieldValue.arrayUnion([userUID])
                    ])
            }
        }
    }
    
    func deletePost() {
        Task {
            do {
                if post.imageReferenceID != "" {
                    try await Storage.storage().reference().child("Post_Images").child(post.imageReferenceID).delete()
                }
                guard let postID = post.id else { return }
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
