//
//  LoginViewController.swift
//  TweeterLogin
//
//  Created by Jekib Alam Haque on 12/09/18.
//  Copyright © 2018 Bishwajit Kalita. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpLoginButton()
    }
    
    fileprivate func setUpLoginButton() {
        
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                self.present(nextViewController, animated:true, completion:nil)
                
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
            
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
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
