
import Foundation


class ApiClient {
    
    var httpMethod = "POST"
    var isReference = false
    var task: URLSessionDataTask?
         
    func setHttpGET() {
        httpMethod = "GET"
    }
    
    func cancelTheApi() {
        task?.cancel()
    }
    
    func isReferenceSetTrue() {
        isReference = true
    }
          
    func apiCall(url:String, body: [String: Any]?, completionHandler: @escaping(BaseClass)->Void) {
        let baseUrl = "https://roamsoft.co:8443/v1/api/"
        let url = URL(string: baseUrl+url)!
        let urlRequest = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
 
        urlRequest.httpMethod = httpMethod
        do {
            if body != nil {
                let json = try JSONSerialization.data(withJSONObject: body as Any, options: [])
                urlRequest.httpBody = json
            }
            var header = ["Content-Type":"application/json","access_for" : "developer_api","Authorization":"Bearer \(StoreUserDefaults.shared.getAuthentication())", "auth_token":StoreUserDefaults.shared.getAuthToken(), "platform" : "api", "merchant_key":StoreUserDefaults.shared.getTheMerchantKey(), "secret_key":StoreUserDefaults.shared.getSecretToken()]
           if isReference {
               header.updateValue(StoreUserDefaults.shared.getReferenceToken(), forKey: "reference_token")
           }
            urlRequest.allHTTPHeaderFields = header
        } catch {
            completionHandler(self.baseClassWithFailedStatement(message: "Transaction Failed"))
            return
        }
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let session = URLSession(configuration: configuration)
        task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            if let code = httpResponse?.statusCode {
                if code == 408 {
                    completionHandler(self.baseClassWithFailedStatement(message: "Time Out"))
                    return
                }
            }
            guard error == nil else {
                completionHandler(self.baseClassWithFailedStatement(message: error!.localizedDescription))
              return
            }
            guard data != nil else {
                completionHandler(self.baseClassWithFailedStatement(message: error!.localizedDescription))
              return
            }
            guard let responseData = data else {
              completionHandler(self.baseClassWithFailedStatement(message: "Transaction Failed"))
              return
            }
            let responseString = String(decoding: responseData, as: UTF8.self)
            print(responseString)
            do {
                let decoder = try JSONDecoder().decode(BaseClass.self, from: responseData)
                completionHandler(decoder)
            } catch {
                completionHandler(self.baseClassWithFailedStatement(message: "Transaction Failed"))
            }
        }
        task?.resume()
    }
    
    func baseClassWithFailedStatement(message: String) -> BaseClass {
        return BaseClass(isSuccess: false, message: "Transaction Failed")
    }
}
