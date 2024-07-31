import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

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
    
    @IBAction func goRegister(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    self.errorLabel.backgroundColor = .systemBackground
                    self.errorLabel.text = error?.localizedDescription
                    print(error!)
                } else {
                    self.performSegue(withIdentifier: K.regToChatSegue, sender: self)
                }
            }
            
        }
    }
    
}
