//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by burak ozen on 24.09.2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        guncel olarak giren kullanıcı neyse onu göstermek amaçlı kullanılan bir obje
        
        
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { [self] authData, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "ERROR")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            
            
        } else {
            makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
        }
        
        
    }
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
//            firebase in create user özelliğni kullanabilmek için kullanılan objedir.
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                
                if error != nil {
//                    olusgturdugumuz alert funcdan alert hatalarını çekerken message inputunda olustudugumuz """error?.localizedDescription"""-- firebase nin kendi alert mesajlarını göstermiş oluyoruz.
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "ERROR")
                    
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
            
        }
        
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

