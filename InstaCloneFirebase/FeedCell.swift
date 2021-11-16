//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by burak ozen on 4.10.2021.
//

import UIKit
import Firebase
import OneSignal

class FeedCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var documentIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!) {
            
            let LikeStore = ["Likes" : likeCount + 1] as [String : Any]
//            veriler guncellemek için .setData olanı alıp için de merge olan özelliktekini seçmemiz gerek merge demek birleiştirmek demek. like ı guncelle ger kalanlara dokunma sadece like ı guncelle demek oluyo.
            fireStoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(LikeStore, merge: true)
            
        }
        
        let userEmail = userEmailLabel.text!
                
                fireStoreDatabase.collection("PlayerId").whereField("email", isEqualTo: userEmail).getDocuments { (snapshot, error) in
                    if error == nil {
                        if snapshot?.isEmpty == false && snapshot != nil {
                            
                            for document in snapshot!.documents {
                                
                                if let playerId = document.get("player_id") as? String {
                                    
                                    //PUSH NOTIFICATION
                                    
                             
                                           OneSignal.postNotification(["contents": ["en":"\(Auth.auth().currentUser!.email!) liked your post "], "include_player_ids": ["\(playerId)"]])


                                }
                                
                            }
                            
                            
                        }
                    }
                }
                
                
                
                
        
        
        
    }
    
    
    

}
