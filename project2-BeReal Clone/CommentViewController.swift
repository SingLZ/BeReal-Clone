//
//  CommentViewController.swift
//  project2-BeReal Clone
//
//  Created by Lixing Zheng on 3/16/24.
//

import Foundation


import UIKit

// TODO: Pt 1 - Import Parse Swift
import ParseSwift

class CommentViewController: UIViewController {
    
    
    
    @IBOutlet weak var commonTextField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func commentButtonTap(_ sender: Any) {
        guard let commentText = commonTextField.text, !commentText.isEmpty else {
            // Handle empty comment text
            print("empty")
            return
        }
        // Create a new comment object
        var comment = Comment()
        comment.text = commentText
        
        print(comment.text)
        // Assign the current user to the `user` property of the comment
        comment.user = User.current!
        
        // Retrieve the latest post from the Parse server
        queryLatestPostAndSaveComment(comment)
    }
    
    private func queryLatestPostAndSaveComment(_ comment: Comment) {
        // Create a query to fetch the latest post from the Parse server
        let query = Post.query()
            .order([.descending("createdAt")])
            .limit(1)
        
        // Fetch the latest post asynchronously
        query.find { [weak self] result in
            switch result {
            case .success(let posts):
                guard var latestPost = posts.first else {
                    fatalError("No posts found")
                }
                
                
                
                // Check if the comments array of the latest post is nil
                if latestPost.comments == nil {
                    // If it's nil, create a new array with the comment
                    latestPost.comments = [comment]
                    print("1")
                    print(latestPost.comments?.first?.text) // Print after adding comments
                } else {
                    // If it's not nil, append the comment to the existing array
                    latestPost.comments?.append(comment)
                    print("2")
                    print(latestPost.comments?.first?.text) // Print after appending comments
                }

                
                // Save the latest post with the updated comments
                latestPost.save { result in
                    switch result {
                    case .success(let savedPost):
                        print("Comment saved successfully for post: \(savedPost)")
                        print("Comment saved: \(savedPost.comments?.first?.text)")
                    case .failure(let error):
                        print("Error saving comment for post: \(error)")
                    }
                }
                
            case .failure(let error):
                print("Error fetching latest post: \(error)")
            }
        }
    }

    
    // Make sure all fields are non-nil and non-empty.
        
        func saveComment(_ comment: Comment, completion: @escaping (Result<Comment, ParseError>) -> Void) {
            print("tf")
            comment.save { result in
                switch result {
                case .success(let savedComment):
                    print("Comment saved successfully: \(savedComment)")
                case .failure(let error):
                    print("Error saving comment: \(error)")
                }
                completion(result)
            }
        }

        
    
    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Sign Up", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to sign you up.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

