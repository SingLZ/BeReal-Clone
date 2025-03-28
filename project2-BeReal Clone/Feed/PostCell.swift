//
//  PostCell.swift
//  project2-BeReal Clone
//
//  Created by Lixing Zheng on 3/6/24.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreLocation
import ImageIO


class PostCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    private var imageDataRequest: DataRequest?
    
    func configure(with post: Post) {
        //TODO: Pt 1 - Configure Post Cell
        // Username
        if let user = post.user {
            usernameLabel.text = user.username
        }
        
        // Image
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {
            
            
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.postImageView.image = image
                    print("Image fetched successfully")
                    
                    
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
        
        // Caption
        captionLabel.text = post.caption
        
        // Date
        if let date = post.createdAt {
            dateLabel.text = DateFormatter.postFormatter.string(from: date)
        }
        
        // Set the location label text
        if let city = post.city, let state = post.state {
            locationLabel.text = "\(city), \(state)"
        } else {
            locationLabel.text = "Location Unknown"
        }
        
        
        //Comments
        if let comment = post.comments?.first?.text {
            commentLabel.text = comment
        } else {
            commentLabel.text = "No Commets Yet"
        }
        
        
        //Time
        if let timeComponents = post.time {
            // Create a calendar instance
            let calendar = Calendar.current
            
            // Create a date from the time components (set the date to a fixed reference date)
            if let date = calendar.date(from: timeComponents) {
                // Use the timeFormatter to format the time component of the date
                let formattedTime = DateFormatter.timeFormatter.string(from: date)
                
                // Set the text of your UILabel to the formatted time
                timeLabel.text = formattedTime
            }
        }
        
        // TODO: Pt 2 - Show/hide blur view
        // A lot of the following returns optional values so we'll unwrap them all together in one big `if let`
        // Get the current user.
        if let currentUser = User.current,
           
            // Get the date the user last shared a post (cast to Date).
           let lastPostedDate = currentUser.lastPostedDate,
           
            // Get the date the given post was created.
           let postCreatedDate = post.createdAt,
           
            // Get the difference in hours between when the given post was created and the current user last posted.
           let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour {
            
            // Hide the blur view if the given post was created within 24 hours of the current user's last post. (before or after)
            blurView.isHidden = abs(diffHours) < 24
        } else {
            
            // Default to blur if we can't get or compute the date's above for some reason.
            blurView.isHidden = false
        }
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //TODO: P1 - Cancel image download
        // Reset image view image.
        //postImageView.image = nil
        
        // Cancel image request.
        //imageDataRequest?.cancel()
    }
    
    
    
}
