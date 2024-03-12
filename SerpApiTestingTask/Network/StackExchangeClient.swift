/// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy

import Foundation

final class StackExchangeClient {
  private lazy var baseURL: URL = {
    return URL(string: "https://serpapi.com")!
  }()
  
  let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
    func fetchImages(with request: ImagesRequest, page: Int, completion: @escaping (Result<ImagesResultResponse, DataResponseError>) -> Void) {
        
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        let parameters = ["ijn": "\(page)"].merging(request.parameters, uniquingKeysWith: +)
        let encodedURLRequest = urlRequest.encode(with: parameters)
        print(encodedURLRequest)
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.hasSuccessStatusCode,
                  let data = data else {
                completion(Result.failure(DataResponseError.network))
                return
            }
            guard let decodedResponse = try? JSONDecoder().decode(ImagesResultResponse.self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            
            completion(Result.success(decodedResponse))
        }).resume()
    }
}
