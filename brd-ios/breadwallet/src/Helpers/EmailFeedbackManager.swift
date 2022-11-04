// 
// Created by Equaleyes Solutions Ltd
//

import Foundation
import MessageUI

class EmailFeedbackManager: NSObject, MFMailComposeViewControllerDelegate {
    struct Feedback {
        let recipients: String
        let subject: String
        let body: String
    }
    
    enum EmailClients: CaseIterable {
        case defaultClient
        
        var name: String {
            switch self {
            case .defaultClient:
                return "Mail"
                
            }
        }
        
        var scheme: String {
            switch self {
            case .defaultClient:
                return "mailto:"
                
            }
        }
        
        var params: String {
            switch self {
            case .defaultClient:
                return "%@?subject=%@&body=%@"
                
            }
        }
    }
    
    private var presentingViewController = UIViewController()
    private let mailVC = MFMailComposeViewController()
    private var feedback: Feedback
    private var completion: ((Result<MFMailComposeResult, Error>) -> Void)?
    
    override init() {
        fatalError("Use FeedbackManager(feedback:)")
    }
    
    init?(feedback: Feedback, on viewController: UIViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            guard let mailTo = (EmailClients.defaultClient.scheme + String(format: EmailClients.defaultClient.params,
                                                                           feedback.recipients,
                                                                           feedback.subject,
                                                                           feedback.body))
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: mailTo) else { return nil }
            
            UIApplication.shared.open(url)
            
            return nil
        }
        
        self.feedback = feedback
        self.presentingViewController = viewController
    }
    
    func send(completion: (@escaping(Result<MFMailComposeResult, Error>) -> Void)) {
        self.completion = completion
        
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([feedback.recipients])
        mailVC.setSubject(feedback.subject)
        mailVC.setMessageBody(feedback.body, isHTML: false)
        
        presentingViewController.present(mailVC, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        mailVC.dismiss(animated: true)
        
        if let error = error {
            completion?(.failure(error))
        } else {
            completion?(.success(result))
        }
    }
}
