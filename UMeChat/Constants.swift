import Foundation

struct K {
    static let logToChatSegue = "LoginToChat"
    static let regToChatSegue = "RegisterToChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    
    struct UMeColors {
        static let meBubble = "MyMessageBubble"
        static let dudeBubble = "DudeMessageBubble"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
