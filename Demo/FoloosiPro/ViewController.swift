//
//  ViewController.swift
//  FoloosiPro
//
//  Created by Quadkast on 23/03/20.
//  Copyright © 2020 roamsoft. All rights reserved.
//

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
        FLog.setLogVisible(debug: true)
        FoloosiPay.initSDK(merchantKey: "test_$2y$10$nBFlhIbZ0xA1A0.-MPvoP.v45N5oiAJeBPomyWw-dya-GEUtqZKiy", withDelegate: self)
        let orderData = OrderData()
        orderData.orderTitle = "OrderTitle"
        orderData.currencyCode = "INR"
        orderData.customColor = "#0000FF"
        orderData.orderAmount = 21
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

extension ViewController: FoloosiDelegate{
    func onPaymentError(descriptionOfError: String) {
        print(descriptionOfError)
    }
    
    func onPaymentSuccess(paymentId: String) {
        print(paymentId)
    }
}
