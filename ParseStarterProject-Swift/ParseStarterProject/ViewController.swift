/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import Bolts

class ViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet var rememberSwitch: UISwitch!
    @IBOutlet weak var login: UIButton!
    func displayAlert(var title:String, var message:String, var action:String, var view:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.Default, handler: nil))
        view.presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func login(sender: AnyObject) {
        if username.text == "" || password.text == "" {
            self.performSegueWithIdentifier("Logon", sender: sender)
            displayAlert("You fucked up!", message: "Username and password are required.", action: "Okay.", view: ViewController())
        }
        
        PFUser.logInWithUsernameInBackground(username.text, password: password.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // do this if good login
                self.performSegueWithIdentifier("Logon", sender: sender)
            } else {
                self.displayAlert("Come on, nigga.", message: "Invalid login credentials.", action: "Try again.", view: ViewController())
            }
        }

    }
    
    @IBAction func signup(sender: AnyObject) {
        
    }
    
    @IBAction func `switch`(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
