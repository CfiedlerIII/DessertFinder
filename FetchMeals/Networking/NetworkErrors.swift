//
//  NetworkErrors.swift
//  FetchMeals
//
//  Created by Charles Fiedler on 8/15/24.
//

import Foundation

enum NetworkError: Error {
  case emptyResponseNoError(HTTPStatusCode)
  case encodingError(Error)
  case decodingError(Error, Data, HTTPStatusCode)
  case badResponse(String, HTTPStatusCode)
  case requestError(String, HTTPStatusCode)
  case badURL(String)
  case genericError(APIError, HTTPStatusCode, Data?)
  case unsatisfiableConnection
}

public struct APIError: Decodable {
  public var message: String
  public let data: String?
  public let status: Int?

  public init(message: String, data: String? = nil, status: Int? = nil) {
    self.message = message
    self.data = data
    self.status = status
  }
}

enum HTTPStatusCode: Int, Error {
  case ok = 200
  case badRequest = 400
  case unauthorized = 401
  case forbidden = 403
  case notFound = 404
  case noResponse = 444
  case internalServerError = 500
  case notImplemented = 501
  case badGateway = 502

  enum ResponseType {
    case success
    case clientError
    case serverError
    case undefined
  }

  var responseType: ResponseType {
    switch rawValue {
    case 200..<300:
        return .success
    case 400..<500:
      return .clientError
    case 500..<600:
      return .serverError
    default:
      return .undefined
    }
  }
}

public extension HTTPURLResponse {
  internal var status: HTTPStatusCode {
    let currentStatus = HTTPStatusCode(rawValue: statusCode) ?? .notImplemented
    return currentStatus
  }
}
