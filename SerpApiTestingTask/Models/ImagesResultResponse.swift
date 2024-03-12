


import Foundation

// MARK: - Welcome
struct ImagesResultResponse: Codable {
    let imagesResults: [ImagesResult]
    let serpapiPagination: SerpapiPagination

    enum CodingKeys: String, CodingKey {
        case imagesResults = "images_results"
        case serpapiPagination = "serpapi_pagination"
    }
}

// MARK: - ImagesResult
struct ImagesResult: Codable {
    let position: Int
    let thumbnail: String
    let source: String
    let title: String
    let link: String
    let original: String
    let originalWidth, originalHeight: Int
    var identifier: String {
        return original
    }
    
    enum CodingKeys: String, CodingKey {
        case position, thumbnail
        case source
        case title, link, original
        case originalWidth = "original_width"
        case originalHeight = "original_height"
    }
    
    func calculateHeight(for width: CGFloat) -> CGFloat {
        let proportions = CGFloat(originalWidth) / CGFloat(originalHeight)
        let height = width / proportions
        return height
    }
}

// MARK: - SerpapiPagination
struct SerpapiPagination: Codable {
    let current: Int
    let next: String?
}


