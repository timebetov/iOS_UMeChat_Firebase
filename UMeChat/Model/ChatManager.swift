import Foundation
import FirebaseFirestore

protocol ChatManagerDelegate {
    func didLoadSuccessfully()
    func didFailedWith(error: Error)
    func didSavedSuccessfully()
}

class ChatManager {
    // delegate
    var delegate: ChatManagerDelegate?
    
    var messages: [Message] = []
    
    // to work with db
    let db = Firestore.firestore()
    
    // loading messages from firestore
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
                
            self.messages = []
            
            if let e = error { // in case of error
                self.delegate?.didFailedWith(error: e)
            } else {
                // in case of successfully retrieved data
                if let snapshotDocs = querySnapshot?.documents {
                    for doc in snapshotDocs {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String,
                           let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessaage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessaage)
                            self.delegate?.didLoadSuccessfully()
                        }
                    }
                }
            }
        }
    }
    
    // sending a data to the db
    func sendDB(sender: String, msg: String) {
        db.collection(K.FStore.collectionName).addDocument(data: [
            K.FStore.senderField: sender,
            K.FStore.bodyField: msg,
            K.FStore.dateField: Date().timeIntervalSince1970
        ]) { error in
            if let e = error {
                self.delegate?.didFailedWith(error: e)
                print("There was an issue saving data to firestore. \n\(e)")
            } else {
                self.delegate?.didSavedSuccessfully()
            }
        }
    }
    
}
