

import Foundation

protocol Model : Equatable {
    var name: String { get set }
    var code: String { get set }
}

class GoogleModel : Equatable {
    
    var name: String
    var code: String
    
    init(model: any Model) {
        self.name = model.name
        self.code = model.code
    }
    
    static func == (lhs: GoogleModel, rhs: GoogleModel) -> Bool {
        lhs.name == rhs.name && lhs.code == rhs.code
    }
    
}

class GoogleCountry: Model, Decodable {
    
    var name: String
    var code: String
    
    static func == (lhs: GoogleCountry, rhs: GoogleCountry) -> Bool {
        lhs.name == rhs.name && lhs.code == rhs.code
    }
    
    private enum CustomCodingKeys: String, CodingKey {
        case countryName = "country_name"
        case countryCode = "country_code"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        name = try container.decode(String.self, forKey: .countryName)
        code = try container.decode(String.self, forKey: .countryCode)
    }

}

class GoogleLanguage: Model, Decodable {
    
    var name: String
    var code: String
    
    static func == (lhs: GoogleLanguage, rhs: GoogleLanguage) -> Bool {
        lhs.name == rhs.name && lhs.code == rhs.code
    }
    
    private enum CustomCodingKeys: String, CodingKey {
        case languageName = "language_name"
        case languageCode = "language_code"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        name = try container.decode(String.self, forKey: .languageName)
        code = try container.decode(String.self, forKey: .languageCode)
    }

}
