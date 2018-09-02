//
//  ViewController.swift
//  securityIniOS
//
//  Created by Usha Natarajan on 8/30/18.
//  Copyright © 2018 Usha Natarajan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText:UITextField!
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var biometricImage: UIImageView!
    
    struct storyBoard{
        static let dimissLogin = "dimissLogin"
        static let loginExists = "loginExists"
        static let signIn = "signIn with user name and password"
        static let signUp = "signUp with user name and password"
        static let touchID = "signIn with username,password or touchID"
        static let faceID = "signIn with username,password or faceID"
        static let userName = "userName"
        static let password = "password"
    }
    
    struct KeychainConfiguration{
        static let serviceName = "BioMetricLogin"
        static let accessGroup:String? = nil
    }
    
    var userName:String? = nil
    var loginExists:Bool = false
    var biometryType = BiometryType.login
    var bioMetricID = BiometricID()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeNavigationBorder()
        //self.view.addGradient(colors:[UIColor.madisonBlue.cgColor,UIColor.init(white: 1.0, alpha: 1.0).cgColor])
        
        loginExists = UserDefaults.standard.bool(forKey: storyBoard.loginExists)
        if loginExists {
            biometryType = self.bioMetricID.bioMetericType()
            self.updateUI(type: biometryType)
            self.userName = fetchUserName() ?? ""
            self.userNameText.text = self.userName
        }else{
            self.biometricImage.image = UIImage()
            self.messageLabel.text = storyBoard.signUp
        }
    }
        
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let touchBool = bioMetricID.canEvalutePolicy()
        if touchBool {
            self.bioMetricLogin()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        self.userNameText.resignFirstResponder()
        self.passwordText.resignFirstResponder()
        
        guard let userName = self.userNameText.text ,
                let password = self.passwordText.text,
            !userName.isEmpty, !password.isEmpty else{
                self.showLoginFailure(message:"Invalid login credentials")
                return
        }
        if !loginExists{
            if self.loginUser(user:userName,password:password){
                self.userName = userName
                UserDefaults.standard.setValue(userName, forKey: storyBoard.userName)
                do {
                    let finalHash = Authorization.passwordHash(from: userName, password: password)
                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: userName, accessGroup: KeychainConfiguration.accessGroup)
                    //try passwordItem.savePassword(password)
                    try passwordItem.savePassword(finalHash)
                }catch let error{
                    fatalError("Error updating keychain:\(error)")
                }
                UserDefaults.standard.set(true, forKey: storyBoard.loginExists)
                self.performSegue(withIdentifier: storyBoard.dimissLogin, sender: self)
            }
        }else{
            if !self.checkLogin(user:userName,password:password){
                return
            }
             self.performSegue(withIdentifier: storyBoard.dimissLogin, sender: self)
        }
       
    }
    
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        DispatchQueue.main.async{
            self.userNameText.text = ""
            self.passwordText.text = ""
        }
        if segue.identifier == storyBoard.dimissLogin{
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.userName = self.userName
        }
    }
    
    
    //Helper methods
    
    func bioMetricLogin(){
        bioMetricID.authencateUser {[weak self] (message) in
            if  message == nil {
                DispatchQueue.main.async{
                    self?.performSegue(withIdentifier: storyBoard.dimissLogin, sender: self)
                }
            }
        }
    }
    
    func showLoginFailure(message:String){
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let loginErrorAlert = UIAlertController(title: "Login Error!", message: message, preferredStyle: .alert)
        loginErrorAlert.addAction(okAction)
        self.present(loginErrorAlert, animated: true, completion: nil)
    }
        
    
    func loginUser(user:String,password:String)->Bool{
        let authentication = self.validate(user: user, password: password)
        if !authentication.success{
            showLoginFailure(message: authentication.message!)
            return false
        }
        return true
    }
    
    func checkLogin(user:String, password:String)->Bool{
        
        guard userName == UserDefaults.standard.value(forKey: storyBoard.userName) as? String,
            userName == user else{
            showLoginFailure(message:"User does not exist")
            return false
        }
        
        do{
            let finalHash = Authorization.passwordHash(from: userName!, password: password)
            let passwordItem = KeychainPasswordItem.init(service: KeychainConfiguration.serviceName, account: userName!, accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            //if password == keychainPassword{
            if finalHash == keychainPassword{
                return true
            }
            showLoginFailure(message:"Invalid password!")
            return false
        }catch let error{
            fatalError("Error reading password from Keychain:\(error)")
        }
        return false
    }
    
    func fetchUserName()-> String?{
        guard let userName = UserDefaults.standard.value(forKey: storyBoard.userName) as? String else{
            return nil
        }
        return userName
    }
    
    func removeNavigationBorder(){ //remove the 1Px line from navigationbar
        let  borderImage = UIImage()
        self.navigationController?.navigationBar.shadowImage = borderImage
        self.navigationController?.toolbar.isHidden = true
    }
    
    func updateUI(type:BiometryType){
        DispatchQueue.main.async{
            switch type{
            case .login:
                self.messageLabel.text = storyBoard.signIn
                self.biometricImage.image = UIImage()
            case .touchID :
                self.messageLabel.text = storyBoard.touchID
                self.biometricImage.image = UIImage(named:type.image)
            case .faceID :
                self.messageLabel.text = storyBoard.faceID
                self.biometricImage.image = UIImage(named:type.image)
            }
        }
    }
    
    
    func validate(user:String,password:String)->(success:Bool,message:String?){
        guard 8...20 ~= password.count && 4...20 ~= user.count  else{
            return(success:false,message:"User name must be 4-20 characters and password must be 8-20 characters long.")
        }
      
        if !user.isAlphanumeric() {
            return(success:false,message:"User name can contain only alpha numeric characters")
        }
        
       if  !password.isPasswordValid() {
        return(success:false,message:"Invalid password, must contain atleat one letter,number and special character")
        }
        return (success:true,message:nil)
    }
}

