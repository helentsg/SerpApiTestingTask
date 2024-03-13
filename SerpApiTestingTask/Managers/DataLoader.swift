

import Foundation

protocol DataLoaderProtocol {
    func fetchModels(for type: ToolListType) async throws -> [GoogleModel]
}

actor DataLoader: DataLoaderProtocol {
    
    func fetchModels(for type: ToolListType) async throws -> [GoogleModel] {
        
        let name = type.fileName
        enum Error: Swift.Error {
            case fileNotFound(name: String)
            case fileDecodingFailed(name: String, Swift.Error)
        }
        guard let url = Bundle.main.url(
            forResource: name,
            withExtension: "json"
        ) else {
            throw Error.fileNotFound(name: name)
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            switch type {
            case .country:
                let decoded = try decoder.decode([GoogleCountry].self, from: data)
                return decoded.map({ GoogleModel(model: $0) })
            case .language:
                let decoded = try decoder.decode([GoogleLanguage].self, from: data)
                return decoded.map({ GoogleModel(model: $0) })
            }
        } catch {
            throw Error.fileDecodingFailed(name: name, error)
        }
        
    }
    
}

