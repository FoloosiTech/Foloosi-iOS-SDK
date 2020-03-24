

import Foundation
import UIKit

enum NetworkError: Error {
    case badURL
}

public class FoloosiPay {
    
    /**
     Payhandler local reference
     */
    static var handler: PayHandler?
    
    /**
     Payment Delegate Reference
     */
    static var delegate: FoloosiDelegate?
    
    /**
     Constructor
     */
    init(){
    }
    
    /**
        * This method should be called before making payment.
        * payment sdk will be initialized here.
        *
        * @param withDelegate  Payment Callback Delegate
        * @param merchantKey your unique merchant key, can be retrieved from foloosi merchant portal.
        */
    public static func initSDK(merchantKey: String, withDelegate: FoloosiDelegate?) {
        self.delegate = withDelegate
        if (FUtils.isEmpty(value: merchantKey)) {
            print("Merchant Key should not be empty")
        } else {
            handler = PayHandler.shared;
            handler!.storeTheMerchantKey(key: merchantKey)
        }
    }
    
    /**
        * @param orderData payment related information like order id,currency,amount...
        */
    public static func makePayment(orderData: OrderData?) {
        if handler == nil {
            FLog.console(message: "Foloosi Pay is not initialized yet. Call FoloosiPay.init()")
        } else if orderData == nil {
            FLog.console(message: "Order Details should not be empty")
        } else {
            handler!.makePayment(orderData: orderData!);
        }
    }
  
    /**
     Return payment callback delegate
     */
    public static func getDeletegate() ->FoloosiDelegate? {
        return delegate
    }
}

