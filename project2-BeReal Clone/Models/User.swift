//
//  User.swift
//  project2-BeReal Clone
//
//  Created by Lixing Zheng on 3/6/24.
//

import ParseSwift
import UIKit

struct User: ParseUser {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // These are required by `ParseUser`.
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?

    // Your custom properties.
    // var customKey: String?
    
    var lastPostedDate: Date?
}
