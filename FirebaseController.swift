//
//  FirebaseController.swift
//  storageApp
//
//  Created by Brock Oberhansley on 6/1/16.
//  Copyright © 2016 Brock Oberhansley. All rights reserved.
//

import UIKit
import Foundation
import FirebaseStorage
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FirebaseController {
    
    static let SharedInstance = FirebaseController()
    
    let uploadProgress = "uploadProgress"
    
    //referance for database
    let DBRef = FIRDatabase.database().reference()
    
    // Points to root referance
    private let storageRef = FIRStorage.storage().referenceForURL("gs://storageapp-212a7.appspot.com")
    
    // Points to image referance
    let iamgeRef = FIRStorage.storage().referenceForURL("gs://storageapp-212a7.appspot.com").child("images")
    
    
    //MARK: Database
    
    static func createUsers(email:String, password:String, completion:(success:Bool) -> Void){
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            
            if (error != nil) {
                //TODO: add error handeling
                completion(success: false)
            }else{
                //TODO: login to account
                completion(success: true)
            }
            
        })
    }
    
    func login(email:String, password:String, completion:(success:Bool)->Void){
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            
            if error != nil {
                //TODO: add error handelin
                //call a alert view
                completion(success: false)
            }else{
                //fetchuser
                
                
                completion(success: true)
            }
        })
    }
    
    
    
    func addUserToDB(username: String) {
    
        DBRef.child("users").childByAutoId().setValue(["username": username])
        
    }
    
    
    //MARK: Upload Images
    func uploadImage(image: NSURL) {
        
        // create file metadata
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        //create an let uploadTask = ...
        let uploadTask = self.iamgeRef.putFile(image, metadata: metadata) { (metadata, error) in
            if (error != nil) {
                NSLog("There was an error uploading image from url: \(error)")
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL
               print(downloadURL)
            }
        }
        
        // this will give the upload progress of the image
        uploadTask.observeStatus(.Progress) { snapshot in
            // Upload reported progress
            if let progress = snapshot.progress {
                let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                //TODO: call the PercentComplete in the progress bar
                
                //broadcast a nsnotification for a progress bar
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName(self.uploadProgress, object: nil)
            }
        }
        
        uploadTask.observeStatus(.Success) { snapshot in
            //TODO: add a uicontroller that the upload was a success
        }
        
        // Errors only occur in the "Failure" case
        uploadTask.observeStatus(.Failure) { snapshot in
            guard let storageError = snapshot.error else { return }
            guard let errorCode = FIRStorageErrorCode(rawValue: storageError.code) else { return }
            switch errorCode {
            case .ObjectNotFound:
                NSLog("File doesn't exist")
                
            case .Unauthorized:
                NSLog("User doesn't have permission to access file")
                
            case .Cancelled:
                NSLog("User canceled the upload")
                
            case .Unknown:
                
                NSLog("Unknown error occurred, inspect the server response")
                
            default: break
            }
           //TODO: add a uicotroller that the upload failed
            
        }
        
    }
    
    //MARK Download image
    func downloadImage(name: String){
        
        let image = self.iamgeRef.child(name)
        
        image.dataWithMaxSize(1*1024*1024) { (data, error) in
            if (error != nil) {
                //TODO: add a uicotroller that the upload failed
                // Uh-oh, an error occurred!
            } else {
                //TODO: add a uicontroller that the upload was a success
                // Data for "images/island.jpg" is returned
                // ... let islandImage: UIImage! = UIImage(data: data!)
            }
        }
    }
    
    //MARK delete file
    func deleteImage(name: String){
        
        let image = self.iamgeRef.child(name)
        
        image.deleteWithCompletion { (error) in
            if (error != nil) {
                //TODO: add a uicontroller that the upload was a failed
                // something went wrong
            } else {
                //TODO: add a uicontroller that the upload was a success
                // File deleted successfully
            }
        }
        
    }
    
    
}
