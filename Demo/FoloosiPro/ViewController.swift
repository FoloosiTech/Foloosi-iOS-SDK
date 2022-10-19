

import UIKit
import FoloosiSdk

class ViewController: UIViewController {
    @IBOutlet weak var stackViewBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var currencyCodeTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        initiateFoloosiPay()
        NotificationCenter.default.addObserver(self, selector: #selector(handelingKeyboard), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handelingKeyboard), name:UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func initiateFoloosiPay(){
        let initData = InitData()
        initData.merchantKey = "Merchant_Key" //"Your Unique Merchant Key"
        initData.customColor = "#122333"  // It must be valid 6 digit hexadecimal color to make payment page loading color as app color.
        FoloosiPay.initSDK(initData: initData, withDelegate: self)
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
        
        //1. Create Order Data Object with necessary inputs and make Payment
        
        let amount = amountTextField.text
        if let value = Double(amount ?? "0.0") {
            if amount == "" || value <= 0 {
                errorAlert(message: "Please enter valid amount")
            } else {
                FLog.setLogVisible(debug: true)
                let orderData = OrderData()
                orderData.orderTitle = "OrderTitle"
                orderData.currencyCode = "INR"
                orderData.orderAmount = value
                orderData.orderId = "Order Id"
                orderData.postalCode = "6000032"
                orderData.state = "TamilNadu"
                orderData.country = "USA"
                orderData.orderDescription = "Order Description"
                orderData.customerUniqueReference = "Customer Unique Reference"
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
    
        /* --------------- OR --------------- */
        
        //2. Pass Reference Token and make Payment
        
        //FoloosiPay.makePaymentWithReferenceToken("YOUR_REFERENCE_TOKEN") // order reference token

    }
    
    func errorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}



extension ViewController: FoloosiDelegate {
    
    func onPaymentError(descriptionOfError: String, transactionId: String, responseCode: String) {
        print(descriptionOfError)
        print(transactionId)
        print(responseCode)
    }
    
    func onPaymentSuccess(transactionId: String, responseCode: String) {
        print(transactionId)
        print(responseCode)
    }
}
