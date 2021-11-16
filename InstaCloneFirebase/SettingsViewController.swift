//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by burak ozen on 27.09.2021.
//

import UIKit
import Firebase


class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
//     logout yapıp segue yapıcaz ama sadece uygulamada değil firebasden de çıkarmamız gerek o yuzden do -try- catch içerisinde yapılması gerkmekte. sonra segue yapıcaz
        self.performSegue(withIdentifier: "toViewController", sender: nil)
        do {
            try Auth.auth().signOut()
            
        } catch {
            print("error")
        }
        
    }
    
    

}
