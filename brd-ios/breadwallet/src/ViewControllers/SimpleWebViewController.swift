// 
// Created by Equaleyes Solutions Ltd
//

import UIKit
import SafariServices

class SimpleWebViewController: SFSafariViewController, SFSafariViewControllerDelegate {
    var didDismiss: (() -> Void)?
    
    struct Model {
        var title: String
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        didDismiss?()
    }
    
    func setup(with model: Model) {
        title = model.title
        delegate = self
    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        guard URL.lastPathComponent == "success" else { return }
        navigationController?.dismiss(animated: true)
    }
}
