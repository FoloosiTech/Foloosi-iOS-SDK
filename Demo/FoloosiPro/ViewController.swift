

import UIKit
import FoloosiSdk

class ViewController: UIViewController {
    @IBOutlet weak var stackViewBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var currencyCodeTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handelingKeyboard), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handelingKeyboard), name:UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        
    }
    
    @objc func handelingKeyboard(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let isKeyboardShow = notification.name == UIResponder.keyboardWillShowNotification
            stackViewBottomConstraints.constant =  isKeyboardShow ? keyboardSize.height : 0
            UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (isSuccess) in                
            }
        }
    }
    
    @IBAction func PayBtnTapped(_ sender: Any) {
        let amount = amountTextField.text
        if let value = Double(amount ?? "0.0") {
            if amount == "" || value < 21 {
                errorAlert(message: "Please enter valid amount")
            } else {
                FLog.setLogVisible(debug: true)
                FoloosiPay.initSDK(merchantKey: "YOUR MERCHANT KEY", withDelegate: self)
                let orderData = OrderData()
                orderData.orderTitle = "OrderTitle"
                orderData.currencyCode = "INR"
                orderData.customColor = "#0000FF"
                orderData.orderAmount = value
                orderData.orderId = "Order Id"
                orderData.orderDescription = "Order Description"
                let customer = Customer()
                customer.customerAddress = "Address"
                customer.customerCity = "City Name"
                customer.customerEmail = "email@gmail.com"
                customer.customerName = "Name"
                customer.customerPhoneCode = ""
                customer.customerPhoneNumber = "1234567893"
                orderData.customer = customer
                FoloosiPay.makePayment(orderData: orderData)
            }
        }
        
        
    }
    
    func errorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}



extension ViewController: FoloosiDelegate{
    func onPaymentError(descriptionOfError: String) {
        print(descriptionOfError)
    }
    
    func onPaymentSuccess(paymentId: String) {
        print(paymentId)
    }
}
