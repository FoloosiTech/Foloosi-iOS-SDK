

import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            if #available(iOS 13.0, *) {
                activityIndicator.style = .large
            } else {
                // Fallback on earlier versions
                activityIndicator.style = .whiteLarge
            }
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
//    override func draw(_ rect: CGRect) {
//    }

}
