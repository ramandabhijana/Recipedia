//
//  StatusCode200TestCase.swift
//  RecipediaTests
//
//  Created by Abhijana Agung Ramanda on 04/02/21.
//

import XCTest
@testable import Core
@testable import Alamofire

class StatusCode200TestCase: XCTestCase {
  
  private var sut: NetworkClient!
  
  override func setUp() {
    super.setUp()
    
    let session: Session = {
      let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        return config
      }()
      return Session(configuration: configuration)
    }()
    
    sut = .shared(session)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
  }
  
  /**
   Tujuan:
   Memeriksa apakah semua endpoint yang digunakan aplikasi merupakan valid
   yang ditandai dengan response status code 200.
   
   General Scenario:
   1. Spesifikasikan endpoint yang akan diuji
   2. Pastikan response memiliki nilai atau tidak nil
   3. Pastikan response memiliki status code 200
   */
  
  func testRecipesReturnsStatusCode200() {
    execute(.listByName("Beef", offset: 0))
  }
  
  func testRecipeReturnsStatusCode200() {
    execute(.detail("716429"))
  }
  
  func testAutocompleteReturnsStatusCode200() {
    execute(.autocomplete("Donut"))
  }
  
  func testClassifyReturnsStatusCode200() {
    execute(.classify)
  }
  
  private func execute(_ route: SpoonacularRouter) {
    MockURLProtocol.responseWithStatusCode(200)
    let expectation = XCTestExpectation(description: "Performs a request")
    
    sut
      .request(route)
      .response { response in
        XCTAssertNotNil(response.response)
        XCTAssertEqual(response.response!.statusCode, 200)
        expectation.fulfill()
      }
    
    wait(for: [expectation], timeout: 3)
  }
  
}
