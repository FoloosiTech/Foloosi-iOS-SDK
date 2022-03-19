# Foloosi iOS SDK Integration

## Step - 1 - Add Dependency

```
pod 'Foloosi-iOS-SDK', '~> 1.3.5'
pod update
```

## Step - 2 - Import SDK 

```
import FoloosiSdk
```


## Step - 3 - Initialize SDK 

To initialize the SDK add the below line of code with the merchant key you retrieved from foloosi merchant panel. If you don't have a merchant key create new one.

```
FoloosiPay.initSDK("Your Unique Merchant Key",withDelegate: Self)
```

## Step - 4 - Create Order Data Object with necessary inputs

You can create the order data or payment input with our OrderData Model class. Here you need to provide order id, title, descripiton, currency code, order amount and customer details like name, email, mobile number.

```
let orderData = OrderData()
orderData.orderTitle = "" // Any Title
orderData.currencyCode = ""  // 3 digit currency code like "AED"
orderData.customColor = "#12233"  // make payment page loading color as app color. 
orderData.orderAmount = 0  // in double format ##,###.##
orderData.orderId = ""  // unique order id. 
orderData.orderDescription = ""  // any description.
orderData.postalCode = "6000032" 
orderData.state = "TamilNadu"
orderData.country = "IN"
orderData.customerUniqueReference = ""  // unique customer reference. 
let customer = Customer()
customer.customerEmail = "email@gmail.com"
customer.customerName = "name"
customer.customerCity = "City"
customer.customerAddress = "Address"
customer.customerPhoneNumber = "1234567890"
orderData.customer = customer

```

## Step - 5 - Make Transaction with Foloosi

Use the below line of code to make the payment with the order data you created in Step - 4

```

FoloosiPay.makePayment(orderData: orderData)

```

## Step - 6 - Implement Payment Delegate

Implement our payment delegate to receive the payment result for the payment we made in Step - 5. Use the below code to obtain the payment result.

```

extension ViewController: FoloosiDelegate{
    func onPaymentError(descriptionOfError: String) {
        // Failure Callback.
    }
    
    func onPaymentSuccess(paymentId: String) {
         // Success Callback
    }
}

```

## iOS 9 Update

iOS 9 has higher requirements for secure URLs. As many Indian banks do not comply with the requirements, you can implement the following as a workaround in Info.plist

```

<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>

```

## Foloosi Log

You can enable / disable the SDK logs by using the below line of code. By default it will be enabled.

```
FLog.setLogVisible(debug: true or false)

```



## Sample Payment Reference.

Please check [this link](https://github.com/FoloosiTech/Foloosi-iOS-SDK/tree/master/Demo) for sample payment with above steps.

