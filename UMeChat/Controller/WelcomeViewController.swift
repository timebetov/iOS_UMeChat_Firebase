import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        errorLabel.text = ""
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
    }

    @IBAction func goLogin(_ sender: UIButton) {
        if let email = emailField.text,
           let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    self.errorLabel.backgroundColor = .systemBackground
                    self.errorLabel.text = e.localizedDescription
                } else {
                    self.performSegue(withIdentifier: K.logToChatSegue, sender: self)
                }
            }
        }
    }
}

