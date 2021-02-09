//
//  MockURLProtocol.swift
//  RecipediaTests
//
//  Created by Abhijana Agung Ramanda on 04/02/21.
//

import Foundation

final class MockURLProtocol: URLProtocol {
  
  enum ResponseType {
      case error(Error)
      case success(HTTPURLResponse)
  }
  
  static var responseType: ResponseType!
  
  private(set) var activeTask: URLSessionTask?
  
  override class func canInit(with request: URLRequest) -> Bool {
    true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }
  
  override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
    false
  }
  
  private lazy var session: URLSession = {
    let config = URLSessionConfiguration.ephemeral
    return URLSession(configuration: config, delegate: self, delegateQueue: nil)
  }()
  
  override func startLoading() {
    // Not interested in making a network request
    // Return the stubbed data immediately
    activeTask = session.dataTask(with: request.urlRequest!)
    activeTask?.cancel()
  }
  
  override func stopLoading() {
    activeTask?.cancel()
  }
}

// MARK: - URLSessionDataDelegate
extension MockURLProtocol: URLSessionDataDelegate {
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    client?.urlProtocol(self, didLoad: data)
  }
  
  // this will return the mocked response
  // We'll either
  //  Fail (request with the given error)
  //  or Succeed the request with the given response
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    switch MockURLProtocol.responseType {
    case .error(let error)?:
      client?.urlProtocol(self, didFailWithError: error)
    case .success(let response)?:
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    default:
      break
    }
    client?.urlProtocolDidFinishLoading(self)
  }
}

extension MockURLProtocol {
  enum MockError: Error {
    case none
  }
  
  // can set the `responseType` anywhere I want
  
  static func responseWithFailure() {
    MockURLProtocol.responseType = .error(MockError.none)
  }
  
  static func responseWithStatusCode(_ code: Int) {
    MockURLProtocol.responseType = .success(
      HTTPURLResponse(
        url: URL(string: "http://localhost:8080")!,
        statusCode: code,
        httpVersion: nil,
        headerFields: nil
      )!
    )
  }
  
}
