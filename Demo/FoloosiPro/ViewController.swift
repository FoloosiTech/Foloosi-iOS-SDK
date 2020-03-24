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
    @IBOutlet weak var currencyCodeTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func PayBtnTapped(_ sender: Any) {
        FoloosiPay.initSDK(merchantKey: "YOUR MERCHANT KEY", withDelegate: self)
        let orderData = OrderData()
        orderData.orderTitle = "OrderTitle"
        orderData.currencyCode = "INR"
        orderData.customColor = "#0000FF"
        orderData.orderAmount = 12
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
        
    }
    
    func onPaymentSuccess(paymentId: String) {
        
    }
}
