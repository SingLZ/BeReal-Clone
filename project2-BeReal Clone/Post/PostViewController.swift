//
//  PostVieweController.swift
//  project2-BeReal Clone
//
//  Created by Lixing Zheng on 3/6/24.
//

import UIKit

// TODO: Import Photos UI
import PhotosUI

// TODO: Import Parse Swift
import ParseSwift

class PostViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var captionTextField: UITextField!
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    private var pickedImage: UIImage?
    private var isGeocoding = false
    var post = Post()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }

    @IBAction func onPickedImageTapped(_ sender: UIButton) {
        // TODO: Pt 1 - Present Image picker
        // Create a configuration object
        var config = PHPickerConfiguration()

        // Set the filter to only show images as options (i.e. no videos, etc.).
        config.filter = .images

        // Request the original file format. Fastest method as it avoids transcoding.
        config.preferredAssetRepresentationMode = .current

        // Only allow 1 image to be selected at a time.
        config.selectionLimit = 1

        // Instantiate a picker, passing in the configuration.
        let picker = PHPickerViewController(configuration: config)

        // Set the picker delegate so we can receive whatever image the user picks.
        picker.delegate = self

        // Present the picker
        present(picker, animated: true)
    }

    @IBAction func onShareTapped(_ sender: Any) {
        // Dismiss Keyboard
        view.endEditing(true)
        
        // TODO: Pt 1 - Create and save Post
        // Unwrap optional pickedImage
        guard let image = pickedImage,
              // Create and compress image data (jpeg) from UIImage
              let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        // Create a Parse File by providing a name and passing in the image data
        let imageFile = ParseFile(name: "image.jpg", data: imageData)
        
        // Create Post object
        //var post = Post()
        
        // Set properties
        post.imageFile = imageFile
        post.caption = captionTextField.text
        
        // Set the user as the current user
        post.user = User.current
        
        
        
        // Call geocodeLocation to update location information
            if let location = locationManager.location {
                geocodeLocation(location) { city, state in
                    // Update post with city and state information
                    self.post.city = city
                    self.post.state = state
                    
                    // Save object in background (async)
                    self.post.save { [weak self] result in
                        if var currentUser = User.current {
                            currentUser.lastPostedDate = Date()
                            // Switch to the main thread for any UI updates
                            DispatchQueue.main.async {
                                // Return to previous view controller
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
        
        // Save object in background (async)
        //post.save { [weak self] result in
          //  if var currentUser = User.current{
            //    currentUser.lastPostedDate = Date()
                // TODO: Pt 2 - Update user's last posted date
                // Switch to the main thread for any UI updates
                // Switch to the main thread for any UI updates
              //  currentUser.save { [weak self] result in
                //    switch result {
                  //  case .success(let post):
                    //    print("✅ Post Saved! \(post)")
                        
                        // TODO: Pt 2 - Update user's last posted date
                        // Switch to the main thread for any UI updates
                      //  DispatchQueue.main.async {
                            // Return to previous view controller
                        //    self?.navigationController?.popViewController(animated: true)
                        //}
                        
                    //case .failure(let error):
                      //  self?.showAlert(description: error.localizedDescription)
                    //}
                //}
            //}
        //}
}

    // Modify geocodeLocation function to accept a completion handler for updating post with location information
    private func geocodeLocation(_ location: CLLocation, completion: @escaping (String?, String?) -> Void) {
        // Reverse geocode the location to get city and state
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil, nil)
                return
            }
            
            if let placemark = placemarks?.first {
                let city = placemark.locality
                let state = placemark.administrativeArea
                completion(city, state)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    
    @IBAction func OnTakePhotoTapped(_ sender: Any) {
        // TODO: Pt 2 - Present camera
        // Make sure the user's camera is available
        // NOTE: Camera only available on physical iOS device, not available on simulator.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌📷 Camera not available")
            return
        }

        // Instantiate the image picker
        let imagePicker = UIImagePickerController()

        // Shows the camera (vs the photo library)
        imagePicker.sourceType = .camera

        // Allows user to edit image within image picker flow (i.e. crop, etc.)
        // If you don't want to allow editing, you can leave out this line as the default value of `allowsEditing` is false
        imagePicker.allowsEditing = true

        // The image picker (camera in this case) will return captured photos via it's delegate method to it's assigned delegate.
        // Delegate assignee must conform and implement both `UIImagePickerControllerDelegate` and `UINavigationControllerDelegate`
        imagePicker.delegate = self

        // Present the image picker (camera)
        present(imagePicker, animated: true)
    }
    
    @IBAction func onViewTapped(_ sender: Any) {
        // Dismiss keyboard
        view.endEditing(true)
    }

    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

// TODO: Pt 1 - Add PHPickerViewController delegate and handle picked image.
extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Dismiss the picker
        picker.dismiss(animated: true)
        
        // Make sure we have a non-nil item provider
        guard let provider = results.first?.itemProvider,
              // Make sure the provider can load a UIImage
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        // Load a UIImage from the provider
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            
            // Make sure we can cast the returned object to a UIImage
            guard let image = object as? UIImage else {
                
                // ❌ Unable to cast to UIImage
                self?.showAlert()
                return
            }
            
            // Check for and handle any errors
            if let error = error {
                self?.showAlert()
                return
            } else {
                
                // UI updates (like setting image on image view) should be done on main thread
                DispatchQueue.main.async {
                    
                    // Set image on preview image view
                    self?.previewImageView.image = image
                    
                    // Set image to use when saving post
                    self?.pickedImage = image
                }
            }
        }
    }
}

// TODO: Pt 2 - Add UIImagePickerControllerDelegate + UINavigationControllerDelegate
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dismiss the image picker
            picker.dismiss(animated: true)

            // Get the edited image from the info dictionary (if `allowsEditing = true` for image picker config).
            // Alternatively, to get the original image, use the `.originalImage` InfoKey instead.
            guard let image = info[.editedImage] as? UIImage else {
                print("❌📷 Unable to get image")
                return
            }

            // Set image on preview image view
            previewImageView.image = image

            // Set image to use when saving post
            pickedImage = image
    }
}



extension PostViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("Error: Unable to retrieve location.")
            return
        }
        
        // Check if a geocoding request is already in progress
        guard !isGeocoding else {
            // Geocoding request is in progress, ignore this update
            return
        }
        
        // Start geocoding
        geocodeLocation(location)
    }
    
    private func geocodeLocation(_ location: CLLocation) {
        // Set flag to indicate geocoding is in progress
        isGeocoding = true
        
        // Reverse geocode the location to get city and state
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            // Reset flag to indicate geocoding is complete
            self.isGeocoding = false
            
            if let error = error {
                // Handle geocoding error
                self.handleGeocodingError(error)
                return
            }
            
            // If there is at least one placemark, extract city and state
            if let placemark = placemarks?.first {
                if let city = placemark.locality, let state = placemark.administrativeArea {
                    // Update current post with city and state
                    self.post.city = city
                    print(city)
                    print(state)
                    self.post.state = state
                }
            }
        }
       
    }
    
    
    private func handleGeocodingError(_ error: Error) {
        if let clError = error as? CLError, clError.code == .network {
            // Network error occurred, display error message to the user
            DispatchQueue.main.async {
                self.showAlert(description: "Unable to retrieve location. Please check your network connection and try again.")
            }
        } else {
            // Generic geocoding error occurred, display generic error message
            DispatchQueue.main.async {
                self.showAlert(description: "An error occurred while retrieving location.")
            }
        }
    }
}
