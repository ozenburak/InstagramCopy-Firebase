//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by burak ozen on 27.09.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
  
    
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    
    var documentIdArray = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        getDataFromfirestore()

        
        
//        PlayerID
        
        let status : OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
                
                let playerId = status.subscriptionStatus.userId
                
                if let playerNewId = playerId {
                    
                    fireStoreDatabase.collection("PlayerId").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
                        if error == nil {
                            if snapshot?.isEmpty == false && snapshot != nil {
                                for document in snapshot!.documents {
                                    if let playerIDFromFirebase = document.get("player_id") as? String {
                                        let documentId = document.documentID
                                        
                                        if playerNewId != playerIDFromFirebase {
                                            
                                            let playerIdDictionary = ["email" : Auth.auth().currentUser!.email!, "player_id" : playerNewId] as! [String : Any]
                                            
                                            self.fireStoreDatabase.collection("PlayerId").addDocument(data: playerIdDictionary) { (error) in
                                                if error != nil {
                                                    print(error?.localizedDescription)
                                                }
                                            }
                                            
                                            
                                        }
                                        
                                    }
                                    
                                }
                                                } else {
                                                    let playerIdDictionary = ["email" : Auth.auth().currentUser!.email!, "player_id" : playerNewId] as! [String : Any]
                                                                                      
                                                    self.fireStoreDatabase.collection("PlayerId").addDocument(data: playerIdDictionary) { (error) in
                                                            if error != nil {
                                                            print(error?.localizedDescription)
                                                                }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        
                                        
                                        
                                        

                                    }
                                    
        
        
        
        

        
        
    }
    
    func getDataFromfirestore(){
        
       
        let fireStoreDataBase = Firestore.firestore()

//        firestore data base de tarih format??yle ilgili herhangi bir s??k??nt?? ya??amam??z durumunda bu yontemle sorunu ????zembiliyoruz ama art??k bu sorun olusmamakta.
        /*
        //        tarih datas?? tutulurken ufak bi ayar yap??lmas?? gerekiyo bu yuzden  settings diye bi de??i??ken olusturuyoruz.
        let settings = fireStoreDataBase.settings
//        settings.areTimestampsInSnapshotsEnabled = true
        fireStoreDataBase.settings = settings
     */
        fireStoreDataBase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
               
                print(error?.localizedDescription)
                
            } else {
                
//                snapshot kullan??caz yani firebasedeki verileri ??ekebilmemiz i??in
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                        
                        
                    }
//                    datam?? reload etmem gerekti??i i??in for loop sonras?? bunu yapmam??z gerekmekte
                    self.tableView.reloadData()
                    
                }
                
                
                
            }
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//olusturdugumuz celleri tan??mlamak i??in kullan??lan fonks """tableView.dequeueReusableCell"""
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
//        burada entera bas??p completion blogu kontrolu yapmam??za gerek yok o yuzden sildik. verimli olmicak completion blok kullan??rsak
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
    


}
