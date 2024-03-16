//
//  Comment.swift
//  project2-BeReal Clone
//
//  Created by Lixing Zheng on 3/16/24.
//

import Foundation
import ParseSwift

struct Comment: ParseObject {
    var originalData: Data?
    
    // Required properties
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    // Additional properties
    var text: String?
    var user: User?
    var post: Post?
}




