

import Foundation

extension Encodable {
    var toDict: [String: Any]?  {
        do {
            let encoder = try JSONEncoder().encode(self)
            guard let json = try JSONSerialization.jsonObject(with: encoder, options: []) as? [String:Any] else { return nil  }
            return json
        } catch {
            return nil
        }
    }
}
