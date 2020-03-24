

import Foundation

internal struct FDefaults {
    static let merchantKey = "merchantKey"
    static let AuthToken = "authToken"
    static let Authentication = "authentication"
    static let referToken = "refertoken"
    static let secretKey = "secretkey"
}

internal struct UrlString {
    static let guestSign = "guest-signup"
    static let initializeSetup = "initialize-setup"
    static let getRequest = "get-access-request"
    static let initializePayment = "user/initiate-payment"
    static let initializeTransaction = "customer/initiate-transaction"
    static let completePayment = "customer/complete-payment"
    static let authUrl = "https://www.roamsoft.co/mobile/success?refid="
    static let cancelUrl = "https://www.roamsoft.co/mobile/decline?refid="
    static let decUrl = "https://www.roamsoft.co/mobile/decline?refid="
}

struct Constants {
    static let noInternet = "No internet connection"
}

internal struct StoreUserDefaults {
    
    static var shared: StoreUserDefaults {
        return StoreUserDefaults()
    }
    
    func setTheMerchantKey(merchantKey: String) {
        UserDefaults.standard.set(merchantKey, forKey: FDefaults.merchantKey)
    }
    
    func setAuthToken(authToken: String) {
        UserDefaults.standard.set(authToken, forKey: FDefaults.AuthToken)
    }
    
    func setReferenceToken(referToken: String) {
        UserDefaults.standard.set(referToken, forKey: FDefaults.referToken)
    }
    
    func setSecretToken(secretKey: String) {
        UserDefaults.standard.set(secretKey, forKey: FDefaults.secretKey)
    }
    
    func setAuthentication(authentication: String) {
        UserDefaults.standard.set(authentication, forKey: FDefaults.Authentication)
    }
    
    func getTheMerchantKey() -> String {
        return UserDefaults.standard.string(forKey: FDefaults.merchantKey) ?? ""
    }
    
    func getSecretToken() -> String  {
        return UserDefaults.standard.string(forKey: FDefaults.secretKey) ?? ""
    }
    
    func getReferenceToken() -> String {
        return UserDefaults.standard.string(forKey: FDefaults.referToken) ?? ""
    }
    
    func getAuthToken() -> String {
        return UserDefaults.standard.string(forKey: FDefaults.AuthToken) ?? ""
    }
    
    func getAuthentication() -> String {
        return UserDefaults.standard.string(forKey: FDefaults.Authentication) ?? ""
    }
}
