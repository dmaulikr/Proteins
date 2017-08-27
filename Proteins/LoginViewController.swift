//
//  LoginViewController.swift
//  Proteins
//
//  Created by lrussu on 6/27/17.
//  Copyright © 2017 lrussu. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    let MyKeychainWrapper = KeychainWrapper()
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    let authenticationContext = LAContext()

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createInfoLabel: UILabel!
    @IBOutlet weak var touchIDButton: UIButton!
    
    func navigateToAuthenticatedViewController() {
        if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "ProteinsVC") {
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(loggedInVC, animated: true)
            }
        }
    }
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage(_ message: String) {
        showAlertWithTitle(title: "Error", message: message)
    }
    
    func errorMessageForLAErrorCode(_ errorCode: Int) -> String {
        var message = ""
        
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
    }
    
    func showAlertWithTitle(title:String, message: String) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }

    func checkLogin(username: String, password: String ) -> Bool {
        if password == MyKeychainWrapper.myObject(forKey: "v_Data") as? String &&
            username == UserDefaults.standard.value(forKey: "username") as? String {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func touchIDLoginAction(_ sender: UIButton) {
        var error: NSError?
        
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
        }
        
        
        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                             localizedReason: "Logging in with Touch ID",
                                             reply: { [unowned self] (success, error) -> Void in
                                                
                                                print("Success = \(success)")
                                                if(success) {
                                                    OperationQueue.main.addOperation({ () -> Void in
                                                        self.navigateToAuthenticatedViewController()
                                                    })
                                                    
                                                } else {
                                                    if let error = error as? NSError {
                                                        let message = self.errorMessageForLAErrorCode(error.code)
                                                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message)
                                                    }
                                                }
        })

    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {

        
       
        
        // 1.
        if (usernameTextField.text == "" || passwordTextField.text == "") {
            let alertView = UIAlertController(title: "Login Problem",
                                              message: "Wrong username or password." as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Foiled Again!", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
            return;
        }
        
        // 2.
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        // 3.
        if sender.tag == createLoginButtonTag {
            
            // 4.
            let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
            if hasLoginKey == false {
                UserDefaults.standard.setValue(self.usernameTextField.text, forKey: "username")
            }
            
            // 5.
            MyKeychainWrapper.mySetObject(passwordTextField.text, forKey: kSecValueData)
            MyKeychainWrapper.writeToKeychain()
            UserDefaults.standard.set(true, forKey: "hasLoginKey")
            UserDefaults.standard.synchronize()
            loginButton.tag = loginButtonTag
            
            performSegue(withIdentifier: "segueProteins", sender: self)
        } else if sender.tag == loginButtonTag {
            // 6.
            if checkLogin(username: usernameTextField.text!, password: passwordTextField.text!) {
                performSegue(withIdentifier: "segueProteins", sender: self)
            } else {
                // 7.
                let alertView = UIAlertController(title: "Login Problem",
                                                  message: "Wrong username or password." as String, preferredStyle:.alert)
                let okAction = UIAlertAction(title: "Foiled Again!", style: .default, handler: nil)
                alertView.addAction(okAction)
                self.present(alertView, animated: true, completion: nil)
            }
        }
        
//        var error: NSError?
//        
//        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
//            showAlertViewIfNoBiometricSensorHasBeenDetected()
//            return
//        }
//        
//
//        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
//                                             localizedReason: "Only awesome people are allowed",
//                                             reply: { [unowned self] (success, error) -> Void in
//                if(success) {
//                    self.navigateToAuthenticatedViewController()
//                } else {
//                    if let error = error as? NSError {
//                        let message = self.errorMessageForLAErrorCode(error.code)
//                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message)
//                    }
//                }
//        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
        
        // 1.
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        // 2.
        if hasLogin {
            loginButton.setTitle("Login", for: UIControlState.normal)
            loginButton.tag = loginButtonTag
            createInfoLabel.isHidden = true
        } else {
            loginButton.setTitle("Create", for: UIControlState.normal)
            loginButton.tag = createLoginButtonTag
            createInfoLabel.isHidden = false
        }
        
        // 3.
        if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            usernameTextField.text = storedUsername as String
        }

        touchIDButton.isHidden = true
        
        if authenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            touchIDButton.isHidden = false
        } else {
            self.showAlertViewAfterEvaluatingPolicyWithMessage("TouchID is not available on the device")
        }
        
        


        
      //  authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                             //                                             localizedReason: "Only awesome people are allowed",
        //                                             reply: { [unowned self] (success, error) -> Void in
        //                if(success) {
        //                    self.navigateToAuthenticatedViewController()
        //                } else {
        //                    if let error = error as? NSError {
        //                        let message = self.errorMessageForLAErrorCode(error.code)
        //                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message)
        //                    }
        //                }
        //        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
