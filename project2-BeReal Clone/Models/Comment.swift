//
//  Comment.swift
//  project2-BeReal Clone
//
//  Created by Lixing Zheng on 3/16/24.
//

import Foundation
import ParseSwift

struct Comment: ParseObject, Identifiable {
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var text: String
    var user: User
    var post: Post
    
    
    init() {
            self.objectId = nil
            self.createdAt = nil
            self.updatedAt = nil
            self.ACL = nil
            self.text = ""
            self.user = User()
            self.post = Post()
        }
}

extension Comment {
    init(text: String, user: User, post: Post) {
        self.text = text
        self.user = user
        self.post = post
    }
}


