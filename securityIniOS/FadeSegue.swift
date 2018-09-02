//
//  File.swift
//  securityIniOS
//
//  Created by Usha Natarajan on 8/30/18.
//  Copyright © 2018 Usha Natarajan. All rights reserved.
//

import UIKit

class FadeSegue: UIStoryboardSegue {
    
    var placeholderView:UIViewController?
    
    override func perform(){
        fade()
    }
    
    func fade(){
        // Get the view of the source
        let sourceViewControllerView = self.source.view
        // Get the view of the destination
        let destinationViewControllerView = self.destination.view
        
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Make the destination view the size of the screen
        destinationViewControllerView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        // Without this line the animation works but the transition is not smooth as it jumps from white to the new view controller
        destinationViewControllerView?.alpha = 0.0
        sourceViewControllerView?.addSubview(destinationViewControllerView!);
        // Animate the fade, remove the destination view on completion and present the full view controller
        
        UIView.animate(withDuration: 2,
                       animations: {
                        destinationViewControllerView?.alpha = 1
        }, completion: { (finished) in
            //destinationViewControllerView?.removeFromSuperview()
            self.source.present(self.destination, animated: false, completion:nil)
        })
    }//end of fade
}
