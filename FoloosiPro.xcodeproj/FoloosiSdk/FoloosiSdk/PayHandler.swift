

import Foundation
import UIKit

internal class PayHandler {
    
    /**
        * Singleton pay handler for handling all payment related works.
    */
    static var shared = PayHandler()
 
    private init(){
        // singleton Constructor
    }
       
    func storeTheMerchantKey(key: String) {
        StoreUserDefaults.shared.setTheMerchantKey(merchantKey: key)
    }
        
    func makePayment(orderData: OrderData) {
        let customer = orderData.customer
        if FUtils.isEmpty(value: orderData.orderId) {
            FLog.console(message: "Order ID can not be empty")
        } else if round(orderData.orderAmount!) <= 0 {
            FLog.console(message: "Order Amount is invalid")
        } else if FUtils.isEmpty(value: orderData.currencyCode) {
            FLog.console(message: "Order Currency Code is invalid")
        } else if customer == nil {
            FLog.console(message: "Order Customer should not be null")
        } else if FUtils.isEmpty(value: customer?.customerName) {
            FLog.console(message: "Customer name is empty")
        } else if FUtils.isEmpty(value: customer?.customerEmail) {
            FLog.console(message: "Customer email is empty")
        } else if FUtils.isEmpty(value: customer?.customerPhoneNumber) {
            FLog.console(message: "Customer mobile number is empty")
        } else if !Reachability.isConnectedToNetwork() {
            FLog.console(message: Constants.noInternet)
        } else {
            floadingView(orderData)
        }
    }
    
    private func floadingView(_ orderData: OrderData) {
        
           var viewController = UIViewController()
           if let topVC = UIApplication.shared.keyWindow?.rootViewController {
               viewController = topVC
               while let top = topVC.presentedViewController {
                   viewController = top
               }
           }
            let fLoadingView = FLoadingVC()
            fLoadingView.delegate = FoloosiPay.getDeletegate()
            fLoadingView.modalPresentationStyle = .fullScreen
            fLoadingView.order = orderData
            let nav = UINavigationController(rootViewController: fLoadingView)
            nav.modalPresentationStyle = .fullScreen
            viewController.present(nav, animated: true, completion: nil)
       }
}

