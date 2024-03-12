

import Foundation

struct ImagesRequest {
  var path: String {
    return "/search.json"
  }
  
  let parameters: Parameters
  private init(parameters: Parameters) {
    self.parameters = parameters
  }
}

extension ImagesRequest {
    static func from(tools: Tools) -> ImagesRequest {
        
        let defaultParameters = ["engine": "google_images",
                                 "api_key": SecretAPI.key]
        
        var parameters = ["ijn":String(tools.start),
                          "num": String(tools.num),
                          "tbm": tools.type.rawValue
        ].merging(defaultParameters, uniquingKeysWith: +)
        
        if tools.size != .any {
            parameters = [ "isz": tools.size.rawValue ].merging(parameters, uniquingKeysWith: +)
        }
        
        if let query = tools.query, !query.isEmpty {
            parameters = [ "q": query ].merging(parameters, uniquingKeysWith: +)
        }
        
        if let language = tools.language {
            parameters = [ "hl" : language.code ].merging(parameters, uniquingKeysWith: +)
        }
        
        if let country = tools.country {
            parameters = [ "gl" : country.code ].merging(parameters, uniquingKeysWith: +)
        }
        
        return ImagesRequest(parameters: parameters)
    }
}
