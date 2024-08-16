//
//  NetworkingService.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/15/24.
//

import Foundation

public enum HTTPMethod: String {
  case GET
  case POST
  case PUT
  case DELETE
  // TODO: Add additional methods as needed
}

class NetworkingService {

  public static let shared = NetworkingService()

  private lazy var configuration: URLSessionConfiguration = {
    let config = URLSessionConfiguration.default
    config.waitsForConnectivity = true
    config.timeoutIntervalForResource = timeout
    return config
  }()
  private let timeout = 60.0

  private lazy var session = URLSession(configuration: configuration)

  public func createRequest(
    forURL url: URL,
    serializedParameteres httpBody: Data?,
    bearerToken: String?,
    httpMethod: HTTPMethod,
    headers: [String: String]?
  ) -> URLRequest {
    let request = NSMutableURLRequest(
      url: url,
      cachePolicy: .useProtocolCachePolicy,
      timeoutInterval: timeout
    )
    request.httpBody = httpBody
    request.allHTTPHeaderFields = headers

    if let token = bearerToken {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    request.httpMethod = httpMethod.rawValue
    return request as URLRequest
  }

  public func executeRequest<DecodableModel: Decodable>(
    _: DecodableModel.Type,
    urlRequest: URLRequest,
    decoder: JSONDecoder = JSONDecoder(),
    queue: DispatchQueue = DispatchQueue.main,
    completion: @escaping (Result<DecodableModel, NetworkError>) -> Void
  ) {

    let completion: ((Result<(Data?, HTTPStatusCode), NetworkError>) -> Void) = { (result) in
      switch result {
      case .success((let data, let statusCode)):
        guard let data = data else {
          queue.async {
            completion(.failure(.emptyResponseNoError(statusCode)))
          }
          return
        }
        do {
          let model = try decoder.decode(DecodableModel.self, from: data)
          queue.async {
            completion(.success(model))
          }
        } catch let decodingError {
          queue.async {
            completion(.failure(NetworkError.decodingError(decodingError, data, statusCode)))
          }
        }

      case .failure(let error):
        queue.async { completion(.failure(error)) }
      }
    }

    let task = handleTask(withRequest: urlRequest, completion: completion)
    task.resume()
  }

  private func handleTask(
    withRequest request: URLRequest,
    completion: @escaping (Result<(Data?, HTTPStatusCode), NetworkError>) -> Void
  ) -> URLSessionTask  {

    let task = session.dataTask(with: request) { (data, response, requestError) in
      let httpResponse = response as? HTTPURLResponse
      let statusCode = httpResponse?.status ?? HTTPStatusCode.noResponse

      // got a 200 range status code
      guard statusCode.responseType == HTTPStatusCode.ResponseType.success else {
        // No response happens when request timeout.
        if case .noResponse = statusCode {
          completion(.failure(.unsatisfiableConnection))
          return
        }

        if let data = data {
          if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
            completion(.failure(.genericError(apiError, statusCode, data)))
          } else {
            completion(.failure(.badResponse(requestError?.localizedDescription ?? "Unknown Error", statusCode)))
          }
        } else {
          completion(.failure(.badResponse(requestError?.localizedDescription ?? "No Error Response Data", statusCode)))
        }
        return
      }

      // but did receive an error message then fail so return that
      if let requestError = requestError {
        completion(.failure(NetworkError.requestError(requestError.localizedDescription, statusCode)))
        return
      }
      // or succeed with possibly some data
      completion(.success((data, statusCode)))
    }

    return task
  }

  public static func handleDecoding<DecodableModel: Decodable>(
    _ : DecodableModel.Type,
    fromData data: Data,
    statusCode: HTTPStatusCode,
    decoder: JSONDecoder = JSONDecoder(),
    queue: DispatchQueue = DispatchQueue.main,
    completion: @escaping (Result<DecodableModel, NetworkError>) -> Void) {
      do {
        let model = try decoder.decode(DecodableModel.self, from: data)
        queue.async {
          completion(.success(model))
        }
      } catch let decodingError {
        print("NetworkConnection: handleDecoding:: Decoding Error - \(decodingError.localizedDescription)")
        queue.async {
          completion(
            .failure(
              .decodingError(
                decodingError,
                data,
                statusCode
              )
            )
          )
        }
      }
    }
}
