

import Foundation

internal struct BaseClass: Codable {
    var isSuccess: Bool = true
    var message: String?
    var data: Data?
        
    enum CodingKeys: String, CodingKey {
        case message
        case data
    }
}

internal struct Data: Codable {
    var authToken: String?
    var authentication: String?
    var reference: String?
    var secret: String?
    var transactionAmount: Double?
    var transactionNo: String?
    var paymentData: PaymentData?
    var apiTransaction: String?
        
    enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
        case authentication = "authentication"
        case reference = "reference_token"
        case secret = "secret_key"
        case paymentData = "payment_data"
        case transactionAmount = "transaction_amount"
        case transactionNo = "transaction_no"
        case apiTransaction = "api_transaction_reference_no"
    }
}

internal struct PaymentData: Codable {
    var referense: String?
    var url: String?
        
    enum CodingKeys: String, CodingKey {
        case referense = "reference_id"
        case url = "url"
    }
}

