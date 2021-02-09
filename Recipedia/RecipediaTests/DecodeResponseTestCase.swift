//
//  DecodeResponseTestCase.swift
//  RecipediaTests
//
//  Created by Abhijana Agung Ramanda on 04/02/21.
//

import XCTest
@testable import Recipe
@testable import Core
@testable import AutocompleteSearch
@testable import Mocker
@testable import Alamofire

//swiftlint:disable force_try
class DecodeResponseTestCase: XCTestCase {
  
  private var session: Session!
  
  override func setUp() {
    let configuration = URLSessionConfiguration.af.default
    configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
    session = Session(configuration: configuration)
  }
  
  func testFetchingRecipes() throws {
    /**
     Skenario:
     1.   Ambil url dari data json lokal dengan metode `url(forResource:, withExtension:)`
        dan coba untuk mendapatkan nilainya. Setelah nilai url didapat, buat objek Data menggunakan url tersebut
        melalui init method `Data(contentsOf:)`
     2.   Spesifikasikan endpoint yang ingin dimock
     3.   Buat objek mock dengan objek data dan endpoint sebagai parameter
        kemudian registrasikan objek mock tersebut
     4.   Buat alamofire request dengan endpoint yang sudah dimock, dan decode responsenya menggunakan tipe
        RecipesResponse.
     5.   Pastikan proses decoding berjalan lancar ditandai dengan
        error == nil dan nilai dari respon (objek RecipesResponse) tidak nil
     6.   Pastikan properti results (array) dari objek RecipesResponse memiliki jumlah 10
     */
    let testBundle = Bundle(for: DecodeResponseTestCase.self)
    let url = try XCTUnwrap(
      testBundle.url(forResource: "recipes", withExtension: "json")
    )
    let mockedData = try Data(contentsOf: url)
    
    let urlEndpoint = try XCTUnwrap(
      SpoonacularRouter.listByName("pasta", offset: 0).asURL()
    )
    let expectation = self.expectation(description: "Request should finish")
    
    registerMock(mockedData, urlEndpoint: urlEndpoint)
    
    session.request(urlEndpoint)
      .responseDecodable(of: RecipesResponse.self) { response in
        XCTAssertNil(response.error)
        XCTAssertNotNil(response.value)
        XCTAssertEqual(response.value?.results.count, 10)
        expectation.fulfill()
      }
      .resume()
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testFetchingRecipe() throws {
    /**
     Skenario:
     1.   Ambil url dari data json lokal dengan metode `url(forResource:, withExtension:)`
        dan coba untuk mendapatkan nilainya. Setelah nilai url didapat, buat objek Data menggunakan url tersebut
        melalui init method `Data(contentsOf:)`
     2.   Spesifikasikan endpoint yang ingin dimock
     3.   Buat objek mock dengan objek data dan endpoint sebagai parameter
        kemudian registrasikan objek mock tersebut
     4.   Buat alamofire request dengan endpoint yang sudah dimock, dan decode responsenya menggunakan tipe
        RecipeResponse.
     5.   Pastikan proses decoding berjalan lancar ditandai dengan
        error == nil dan nilai dari respon (objek RecipeResponse) tidak nil
     */
    let testBundle = Bundle(for: DecodeResponseTestCase.self)
    let url = try XCTUnwrap(
      testBundle.url(forResource: "recipe", withExtension: "json")
    )
    let mockedData = try Data(contentsOf: url)
    
    let urlEndpoint = try XCTUnwrap(
      SpoonacularRouter.detail("716429").asURL()
    )
    
    let expectation = self.expectation(description: "Request should finish")
    
    registerMock(mockedData, urlEndpoint: urlEndpoint)
    
    session.request(urlEndpoint)
      .responseDecodable(of: RecipeResponse.self) { response in
        XCTAssertNil(response.error)
        XCTAssertNotNil(response.value)
        XCTAssertEqual(response.data, mockedData)
        XCTAssertEqual(
          response.value!.id,
          try! JSONDecoder().decode(RecipeResponse.self, from: mockedData).id
        )
        expectation.fulfill()
      }
      .resume()
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testFetchingAutocomplete() throws {
    /**
     Skenario:
     1.   Ambil url dari data json lokal dengan metode `url(forResource:, withExtension:)`
        dan coba untuk mendapatkan nilainya. Setelah nilai url didapat, buat objek Data menggunakan url tersebut
        melalui init method `Data(contentsOf:)`
     2.   Spesifikasikan endpoint yang ingin dimock
     3.   Buat objek mock dengan objek data dan endpoint sebagai parameter
        kemudian registrasikan objek mock tersebut
     4.   Buat alamofire request dengan endpoint yang sudah dimock, dan decode responsenya menggunakan tipe
        Array of AutocompleteResponse.
     5.   Pastikan proses decoding berjalan lancar ditandai dengan
        error == nil
     6.   Pastikan nilai dari respon (objek array bertipe AutocompleteResponse) tidak nil dan berjumlah 10
     */
    let testBundle = Bundle(for: DecodeResponseTestCase.self)
    let url = try XCTUnwrap(
      testBundle.url(forResource: "autocomplete", withExtension: "json")
    )
    let mockedData = try Data(contentsOf: url)
    
    let urlEndpoint = try XCTUnwrap(
      SpoonacularRouter.autocomplete("chick").asURL()
    )
    
    let expectation = self.expectation(description: "Request should finish")
    
    registerMock(mockedData, urlEndpoint: urlEndpoint)
    
    session.request(urlEndpoint)
      .responseDecodable(of: [AutocompleteResponse].self) { response in
        XCTAssertNil(response.error)
        XCTAssertNotNil(response.value)
        XCTAssertEqual(response.data, mockedData)
        XCTAssertEqual(response.value!.count, 10)
        expectation.fulfill()
      }
      .resume()
    
    wait(for: [expectation], timeout: 5)
  }
  
  private func registerMock(_ mockedData: Data, urlEndpoint: URL) {
    let mock = Mock(
      url: urlEndpoint,
      dataType: .json,
      statusCode: 200,
      data: [.get: mockedData]
    )
    mock.register()
  }
  
}
