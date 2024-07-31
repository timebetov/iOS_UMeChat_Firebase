import UIKit

class ChatViewController: UIViewController {
    
    // Interface Builder Outlets
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    
    // Managers
    var chatManager = ChatManager()
    var authManager = AuthManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        chatManager.delegate = self
        authManager.delegate = self
        
        // removing the title from send button
        sendBtn.setTitle("", for: .normal)

        // Navigation settings
        self.title = "Chat"
        self.navigationItem.hidesBackButton = true
        
        // registering the cell to table view
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        // Load messages from db
        chatManager.loadMessages()
    }
    
    // send message button pressed
    @IBAction func sendMsg(_ sender: UIButton) {
        if let messageBody = messageField.text,
           let messageSender = authManager.getEmail() {
            if !messageBody.isEmpty {
                let msgBody = messageBody.trimmingCharacters(in: .whitespaces)
                print("New message: \(msgBody)")
                self.chatManager.sendDB(sender: messageSender, msg: msgBody)
            }
        }
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        authManager.logOut() // logging out the current user from service
    }
}

// MARK: - AuthManagerDelegate
extension ChatViewController: AuthManagerDelegate {
    func logOutFail(with error: NSError) {
        print("Error signing out: %@", error)
    }
    
    func logOutSuccess() {
        self.navigationController?.popToRootViewController(animated: true)
        print("You Successfully signed out!")
    }
}

// MARK: - ChatManagerDelegate
extension ChatViewController: ChatManagerDelegate {
    func didSavedSuccessfully() {
        print("Successfully saved data!")
        DispatchQueue.main.async {
            self.messageField.text = ""
        }
    }
    
    func didLoadSuccessfully() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.chatManager.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    func didFailedWith(error: Error) {
        print("There was an issue while retrieving data from database, \(error)")
    }
    
    
}

// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatManager.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        let message = self.chatManager.messages[indexPath.row]
        cell.label.text = message.body
        
        // message from current user
        if message.sender == authManager.getEmail() {
            cell.dudeImg.isHidden = true
            cell.userImg.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.UMeColors.meBubble)
        }
        // message from another sender
        else {
            cell.dudeImg.isHidden = false
            cell.userImg.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.UMeColors.dudeBubble)
        }

        return cell
    }
    
    
}
