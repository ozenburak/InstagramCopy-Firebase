//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by burak ozen on 27.09.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        tekrardan olusturulan imageView un tıklanabilir olması lazım ki kullanıcı foto seçebilsin.
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    @objc func chooseImage() {
//        foto seçebilme özelliğini picker
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
//        burada storage a ulasıp child doediğimizde onun bi alt kademedeki dosya moduna ulasıyoruz.
        let mediaFolder = storageReference.child("media")
        
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
//            uu id verip onu string cevifiyo bu sayede her dafeında farkı uniq bir id alabiliyo
            let uuid = UUID().uuidString
//            burada child olarak uuid vermemizdeki neden her defasında kaydedilen fotoların her birine farklı bir id verip media klasorune kayıt işlemi yapabilsin diye. sonun stringin jpg olarak algılıyoruz ki storage a kayıt edilen görsellerde sıkıntı çıkmasın diye
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    
                    imageReference.downloadURL { url, error in
                        
                        if error == nil {
//                            url mi al string cevir anlamında
                            let imageUrl = url?.absoluteString
                            
                            
//                            ****-----DATABASE-----****
                            
                            let fireStoreDatabase = Firestore.firestore()
//                            databse içerisinde yazmak okumak gibi eylemelri yapabilmek için kullanılan objedir -- DocumentReference
                            var fireStoreReference : DocumentReference? = nil
                            
//                            bir dictionary olusturucaz reference içerisinde kullanabilmek için
//                            FieldValue.serverTimestamp() ----> bu bize direk o zaman neyse kullanıcnın bastıgı zama nneyse onu verir.
                            let fireStorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "like" : 0 ] as [String : Any]
                            
                            fireStoreReference = fireStoreDatabase.collection("Posts").addDocument(data: fireStorePost, completion: { error in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                    
                                } else {
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = ""
// selectedIndex ----> tabbar içerisinde kaçıncı indexe götüriyim onu soyleyebilememize yarar. 0 dersek feed , 1--> upload, 2--> settings e goturur.
                                    self.tabBarController?.selectedIndex = 0
                                    
                                    
                                }
                            })
                            
                            
                            
                        }
                    }
                    
                }
                    
            }
            
        }
        
        
        
    }
    
    

}
