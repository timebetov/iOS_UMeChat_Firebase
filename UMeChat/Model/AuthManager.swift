import Foundation
import FirebaseAuth

protocol AuthManagerDelegate {
    func logOutFail(with error: NSError)
    func logOutSuccess()
}

class AuthManager {
    var delegate: AuthManagerDelegate?
    // get current user's email field
    func getEmail() -> String? {
        if let email = Auth.auth().currentUser?.email {
            return email
        } else {
            return nil
        }
    }
    
    // log out user from service
    func logOut() {
        do {
            try Auth.auth().signOut()
            delegate?.logOutSuccess()
        } catch let signOutError as NSError {
            delegate?.logOutFail(with: signOutError)
        }
    }
}
