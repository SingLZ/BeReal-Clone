//
//  Post.swift
//  project2-BeReal Clone
//
//  Created by Lixing Zheng on 3/6/24.
//

import ParseSwift
import UIKit

struct Post: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own custom properties.
    var caption: String?
    var user: User?
    var imageFile: ParseFile?
    
    
    var latitude: Double?
    var longitude: Double?
    var city : String?
    var state : String?
}
