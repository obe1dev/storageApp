//
//  LoginViewController.swift
//  storageApp
//
//  Created by Brock Oberhansley on 6/16/16.
//  Copyright © 2016 Brock Oberhansley. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailSignUn(sender: AnyObject) {
        
        guard let email = emailTextField.text else{
            
            addAlertController("email")
            return
        }
        
        guard let password = passwordTextField.text else {
            
            addAlertController("password")
            return
        }
        
        FirebaseController.createUsers(email, password: password) { (success) in
            if(success){
                NSLog("successfully creaded a user")
            }
            else{
                NSLog("failure in create user")
            }
        }
    }
    
    @IBAction func emailLogin(sender: AnyObject) {
        
        if(emailTextField.text == ""){
            
            addAlertController("email")
            return
        }
        
        if(passwordTextField.text == ""){
            
            addAlertController("password")
            return
        }
        guard let email = emailTextField.text else{
            return
        }
        
        guard let password = passwordTextField.text else {
            return
        }
        
        FirebaseController.SharedInstance.login(email, password: password) { (success) in
            if(success){
                NSLog("successfully Loged in a user!")
            }
        }
    }
    
    @IBAction func facebookLogin(sender: AnyObject) {
        
    }
    
    func addAlertController(title: String){
        let alertController = UIAlertController(title: title, message: String(format: "please enter %@",title), preferredStyle: .Alert)
        let cancelAction  = UIAlertAction(title: "Cancel", style: .Cancel) { (Action) in
            if(title == "email"){
                self.emailTextField.focused
            }else{
                self.passwordTextField.focused
            }
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) { 
            //
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
