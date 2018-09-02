//
//  DetailViewController.swift
//  securityIniOS
//
//  Created by Usha Natarajan on 8/30/18.
//  Copyright © 2018 Usha Natarajan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    struct storyBoard{
        static let logout = "unwindToLogin"
    }
    
    let logoutImage = UIImage(named:"logout")
    var userName:String!{
        didSet{
            self.title = userName!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterBackground(_:)),name: .UIApplicationWillResignActive, object: nil)
        DispatchQueue.main.async(){
            self.navigationController?.navigationBar.backIndicatorImage = UIImage()
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
            self.navigationController?.navigationBar.backItem?.title = " "
            self.navigationController?.toolbar.isTranslucent = false
            self.navigationController?.toolbar.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTapLogout(_ sender: UIButton) {
        self.performSegue(withIdentifier: storyBoard.logout, sender: self)
    }
    
    @objc func appWillEnterBackground(_ notification:Notification)->Void{
        self.performSegue(withIdentifier: storyBoard.logout, sender: self)
    }
    
}
