//
//  HomeView.swift
//  TweeterLogin
//
//  Created by Jekib Alam Haque on 17/09/18.
//  Copyright © 2018 Bishwajit Kalita. All rights reserved.
//

import UIKit

class HomeView: NSObject {

    let loadingIndicator = UIActivityIndicatorView()

    public func showActivityIndicator(view: UIView) {
        loadingIndicator.center = view.center
        loadingIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingIndicator.isUserInteractionEnabled = false
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        loadingIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        view.addSubview(loadingIndicator)
    }
    
    public func stopActivityIndicator(view : UIView) {
        
        self.loadingIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    public func showAlert(viewController : UIViewController){
    
         let alert = UIAlertController(title: "Message" , message:"Tweet section is under development", preferredStyle: UIAlertControllerStyle.alert)
         let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
        })
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public func showAlertForLogout(viewController : UIViewController){
        
        let alert = UIAlertController(title: "Message" , message:"Are you sure to exit?", preferredStyle: UIAlertControllerStyle.alert)
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            viewController.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
        })
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
