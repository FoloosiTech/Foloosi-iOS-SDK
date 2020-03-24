import UIKit
import WebKit

public protocol FoloosiDelegate {
    func onPaymentError(descriptionOfError: String)
    func onPaymentSuccess(paymentId: String)
}

internal class FLoadingVC: UIViewController {
    
    var loadingView: LoadingView?
    var activityIndicatorForWeb: LoadingView?
    var order: OrderData?
    var webView: WKWebView?
    var webViewPopUp: WKWebView?
    var customer: Customer?
    var delegate: FoloosiDelegate?
    private var transactionId = ""
    private var transactionNo = ""
    private var referenceToken = ""
    private var apiTransaction = ""
    private var paymentTransaction = ""
    var colorCode = ""
    var apiClient: ApiClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customer = order?.customer
        colorCode = order?.customColor ?? "#1654C2"
        setupTheLoadingView()
        guestApiCall()
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTapped))
        self.navigationItem.rightBarButtonItem = cancelBtn
    }
    
    @objc func cancelBtnTapped() {
        let alert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel this transaction?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.apiClient?.cancelTheApi()
            self.dismissTheView(message: "Cancelled")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
        
    func guestApiCall() {
        if Reachability.isConnectedToNetwork() {
            let customers = ["name":customer?.customerName, "email":customer?.customerEmail, "phone_number":customer?.customerPhoneNumber, "phone_code":customer?.customerPhoneCode ?? "", "customer_address":customer?.customerAddress ?? "", "customer_city":customer?.customerCity ?? ""]
            apiClient = ApiClient()
            apiClient?.apiCall( url: UrlString.guestSign, body: customers as [String : Any]) { (baseClass) in
                if baseClass.isSuccess {
                    StoreUserDefaults.shared.setAuthToken(authToken: baseClass.data?.authToken ?? "")
                    StoreUserDefaults.shared.setAuthentication(authentication: baseClass.data?.authentication ?? "")
                    self.initialSetup()
                } else {
                    self.dismissTheView(message: baseClass.message!)
                }
            }
        } else {
            self.dismissTheView(message: Constants.noInternet)
        }
    }
    
    func initialSetup() {
        if Reachability.isConnectedToNetwork() {
            let customers = ["customer_name": self.customer?.customerName, "customer_email": self.customer?.customerEmail, "customer_mobile":self.customer?.customerPhoneNumber ?? "", "customer_address":self.customer?.customerAddress ?? "", "customer_city":self.customer?.customerCity ?? "", "redirect_url" : "", "transaction_amount" : "22.22" , "currency" : self.order?.currencyCode ?? "" ] as [String : Any]
            apiClient = ApiClient()
            apiClient?.apiCall(url: UrlString.initializeSetup, body: customers) { (baseClass) in
                if baseClass.isSuccess {
                    StoreUserDefaults.shared.setReferenceToken(referToken: baseClass.data?.reference ?? "")
                    self.getAccessRequest()
                } else {
                    self.dismissTheView(message: baseClass.message!)
                }
            }
        } else {
            self.dismissTheView(message: Constants.noInternet)
        }
    }
    
    func getAccessRequest() {
        if Reachability.isConnectedToNetwork() {
            apiClient = ApiClient()
            apiClient?.isReferenceSetTrue()
            apiClient?.setHttpGET()
            apiClient?.apiCall(url: UrlString.getRequest, body: nil) { (baseClass) in
                if baseClass.isSuccess {
                    StoreUserDefaults.shared.setReferenceToken(referToken: baseClass.data?.reference ?? "")
                    StoreUserDefaults.shared.setSecretToken(secretKey: baseClass.data?.secret ?? "")
                    self.initPayment(transactionAmount: baseClass.data?.transactionAmount ?? 0.0, transactionId: baseClass.data?.transactionNo ?? "")
                } else {
                    self.dismissTheView(message: baseClass.message!)
                }
            }
        } else {
            self.dismissTheView(message: Constants.noInternet)
        }
    }
    
    func initPayment(transactionAmount: Double, transactionId: String) {
        if Reachability.isConnectedToNetwork() {
            let dict = ["amount":transactionAmount,
                        "color_code":colorCode , "description":order?.orderDescription,"authUrl":UrlString.authUrl + transactionId,"canUrl":UrlString.cancelUrl + transactionId,"decUrl":UrlString.decUrl + transactionId] as [String : Any]
            apiClient = ApiClient()
            apiClient?.apiCall(url: UrlString.initializePayment, body: dict as [String: Any]) { (baseClass) in
                if baseClass.isSuccess {
                    self.initTransaction(referenceId: baseClass.data?.paymentData?.referense ?? "", transactionId: transactionId, url: baseClass.data?.paymentData?.url ?? "")
                } else {
                    self.dismissTheView(message: baseClass.message!)
                }
            }
        } else {
            self.dismissTheView(message: Constants.noInternet)
        }
    }
    
    func initTransaction(referenceId: String, transactionId: String, url: String) {
        if Reachability.isConnectedToNetwork() {
            let dict = ["transaction_id":referenceId,"reference_token":StoreUserDefaults.shared.getReferenceToken(),"api_transaction_reference_no":transactionId]
            self.transactionId = referenceId
            self.referenceToken = StoreUserDefaults.shared.getReferenceToken()
            self.apiTransaction = transactionId
            apiClient = ApiClient()
            apiClient?.apiCall(url: UrlString.initializeTransaction, body: dict as [String: Any]) { (baseClass) in
                if baseClass.isSuccess {
                    self.transactionNo = (baseClass.data?.transactionNo)!
                    self.openWebView(url: url)
                } else {
                    self.dismissTheView(message: baseClass.message!)
                }
            }
        } else {
            self.dismissTheView(message: Constants.noInternet)
        }
    }
    
    func openWebView(url: String) {
        DispatchQueue.main.async {
            if let url = URL(string: url) {
                self.webView = WKWebView(frame: .zero)
                self.webView?.navigationDelegate = self
                self.webView?.autoresizesSubviews = true
                self.webView?.uiDelegate = self
                self.webView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.webView?.configuration.preferences.javaScriptEnabled = true
                self.webView?.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
                self.webView?.allowsBackForwardNavigationGestures = true
                self.webView?.configuration.userContentController.add(self, name: "jshandler")
                let urlRequest: URLRequest = URLRequest(url: url)
                self.webView?.load(urlRequest)
                self.activityIndicatorForWeb = Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)?.first as? LoadingView
                self.activityIndicatorForWeb?.activityIndicator.isHidden = false
            
                    self.activityIndicatorForWeb?.activityIndicator.color = UIColor.init(hexString: self.colorCode)
                self.activityIndicatorForWeb?.activityIndicator.startAnimating()
                self.webView?.addSubview(self.activityIndicatorForWeb!)
                self.view.addSubview(self.webView!)
                self.activityIndicatorForWeb!.translatesAutoresizingMaskIntoConstraints = false
                self.activityIndicatorForWeb!.centerXAnchor.constraint(equalTo: self.webView!.centerXAnchor).isActive = true
                self.activityIndicatorForWeb!.centerYAnchor.constraint(equalTo: self.webView!.centerYAnchor).isActive = true
                self.activityIndicatorForWeb?.topAnchor.constraint(equalTo: self.webView!.topAnchor, constant: 0).isActive = true
                self.activityIndicatorForWeb?.leadingAnchor.constraint(equalTo: self.webView!.leadingAnchor, constant: 0).isActive = true
                self.activityIndicatorForWeb?.trailingAnchor.constraint(equalTo: self.webView!.trailingAnchor, constant: 0).isActive = true
                self.activityIndicatorForWeb?.bottomAnchor.constraint(equalTo: self.webView!.bottomAnchor, constant: 0).isActive = true
                self.webView?.translatesAutoresizingMaskIntoConstraints = false
                self.webView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
                self.webView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
                self.webView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
                self.webView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            }
        }
    }
    
    func completePayment(_ paymentTransaction: String) {
        webView?.removeFromSuperview()
        if Reachability.isConnectedToNetwork() {
            let dict = ["transaction_id":transactionId,"transaction_no":transactionNo,"reference_token":referenceToken,"api_transaction_reference_no":apiTransaction, "payment_transaction_id":paymentTransaction]
            apiClient = ApiClient()
            apiClient?.apiCall(url: UrlString.completePayment, body: dict as [String: Any]) { (baseClass) in
                if baseClass.isSuccess {
                    self.dismissTheViewWithSuccess(message: (baseClass.data?.transactionNo!)!)
                } else {
                    self.dismissTheView(message: baseClass.message!)
                }
            }
        } else {
            self.dismissTheView(message: Constants.noInternet)
        }
    }
    
    func setupTheLoadingView() {
      
        loadingView = Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)?.first as? LoadingView
        loadingView?.activityIndicator.isHidden = false
        loadingView?.activityIndicator.color = UIColor.init(hexString: colorCode)
        loadingView?.activityIndicator.startAnimating()
        view?.addSubview(loadingView!)
        loadingView?.translatesAutoresizingMaskIntoConstraints = false
        loadingView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        loadingView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        loadingView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        loadingView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func dismissTheView(message: String) {
        DispatchQueue.main.async {
            
            self.dismiss(animated: true){
                self.delegate?.onPaymentError(descriptionOfError: message)
            }
        }
        
    }
    
    func dismissTheViewWithSuccess(message: String) {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.delegate?.onPaymentSuccess(paymentId: message)
            }
        }
    }
    
}

extension FLoadingVC : WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate {

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webViewPopUp = WKWebView(frame: view.bounds, configuration: configuration)
        webViewPopUp?.configuration.preferences.javaScriptEnabled = true
        webViewPopUp?.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        webViewPopUp?.allowsBackForwardNavigationGestures = true
        webViewPopUp?.navigationDelegate = self
        webViewPopUp?.autoresizesSubviews = true
        webViewPopUp?.uiDelegate = self
        view.addSubview(webViewPopUp!)
        webViewPopUp?.translatesAutoresizingMaskIntoConstraints = false
        webViewPopUp?.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        webViewPopUp?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        webViewPopUp?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        webViewPopUp?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        return webViewPopUp!
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .other  {
            if let url = navigationAction.request.url {
                decisionHandler(.allow)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicatorForWeb?.activityIndicator.isHidden = true
        self.activityIndicatorForWeb?.activityIndicator.stopAnimating()
        self.activityIndicatorForWeb?.removeFromSuperview()
    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityIndicatorForWeb?.activityIndicator.isHidden = false
        self.activityIndicatorForWeb?.activityIndicator.startAnimating()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let jsonBody = String(describing: message.body)
        let jsonData = jsonBody.data(using: .utf8)!
        do {
            let json =  try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
             if let str = json as? [String: Any] {
                let localTransactionId = FUtils.clearNil(value: str["transaction_id"] as? String)
                if localTransactionId.isEmpty {
                     dismissTheView(message:(str["message"] as? String)!)
                 } else {
                    completePayment(localTransactionId)
                 }
            }
        } catch {
            dismissTheView(message:"Transaction Failed")
        }
        
    }
}
