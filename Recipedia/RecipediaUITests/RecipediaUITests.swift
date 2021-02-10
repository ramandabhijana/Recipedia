//
//  RecipediaUITests.swift
//  RecipediaUITests
//
//  Created by Abhijana Agung Ramanda on 01/02/21.
//

import XCTest

class RecipediaUITests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
  }
  
  func testAutocompleteSearch() {
    /**
     Catatan tambahan:
     Apabila test ini gagal di line 67 dengan pesan kesalahan seperti ini
     "Failed to get matching snapshot: No matches found for Descendants matching type Keyboard from input"
     Ini terjadi karena simulator tidak menampilkan software keyboard
     Lakukan hal berikut:
     pilih window simulator, pada menu bar pilih I/O -> Keyboard -> unchecklist di Connect hardware keyboard
     
     Skenario:
     1.   Ketuk tombol yang memiliki icon search di pojok kanan atas (trailing navigation bar)
     2.   Pada halaman pencarian, masukkan kata kunci "chick"
     3.   Beri waktu 5dtk untuk autocomplete list dapat ditampilkan
     4.   Ketuk cell pertama untuk masuk ke halaman detail
     5.   Program akan mencari detail dari recipe berdasarkan ID, jadi pastikan muncul indikasi loading
     6.   Pastikan nama dari resep muncul setelah menunggu 5dtk dan pastikan juga nama dari resep
        mengandung kata kunci pencarian yang ada pada nomer 2
     7.   Untuk memastikan apakah halaman detail yang ditampilkan, pastikan terdapat tombol
        bookmark di pojok kanan atas (trailing navigation bar)
     8.   Ketuk tombol kembali (back button) dan ketuk tombol search/return pada keyboard
        untuk menampilkan list dari recipe
     9.   Pastikan list recipe muncul setelah menunggu 5dtk
     */
    let app = XCUIApplication()
    app.launch()
    
    app.navigationBars.buttons["magnifyingglass.circle"].tap()
    
    let text = "chick"
    _ = app.tables.searchFields["Search"].waitForExistence(timeout: 2)
    app.searchFields["Search"].typeText(text)
    
    let list = app.tables["results"]
    _ = list.waitForExistence(timeout: 5)
    XCTAssert(list.exists)
    
    list.cells.element(boundBy: 0).tap()
    
    let loading = app.staticTexts["loading"]
    XCTAssert(loading.exists)
    
    let title = app.staticTexts["title"]
    _ = title.waitForExistence(timeout: 5)
    XCTAssert(title.exists)
    
    let titleText = title.label.lowercased()
    XCTAssert(titleText.contains(text))
    
    XCTAssert(
      app.navigationBars.buttons["bookmark.fill"].exists
        || app.navigationBars.buttons["bookmark"].exists
    )
    
    app.navigationBars.buttons.element(boundBy: 0).tap()
    app.keyboards.buttons["search"].tap()
    
    let recipeList = app.tables["remote_recipes"]
    _ = recipeList.waitForExistence(timeout: 5)
    XCTAssert(recipeList.exists)
  }
  
  func testAddRecipeToFavorite() {
    /**
     Skenario:
     1.   Pastikan ada di tab home, tunggu 7dtk sampai list muncul
     2.   Ketuk cell dari list untuk beralih ke halaman detail recipe dan
        pastikan recipe tersebut belum dijadikan favorite.
        Special case
        - Apabila recipe sudah difavoritkan, kembali ke halaman list dan ketuk cell berikutnya.
        - Jika sampai cell terakhir ditemukan bahwa semua cell sebelumnya berisi recipe yang sudah difavoritkan,
          Ketuk tombol bookmark untuk menghilangkan dari favorite terlebih dahulu
     3.   Ketuk tombol bookmark di pojok kanan atas (di trailing navigation bar)
        dan pastikan muncul pesan indikasi berhasil dimasukkan.
     4.   Pastikan tombol bookmark sekarang berganti icon
     */
    let app = XCUIApplication()
    app.launch()
    
    addRecipeToFavoriteFromHome(app: app)
  }
  
  private func addRecipeToFavoriteFromHome(app: XCUIApplication) {
    app.tabBars.buttons["Home"].tap()
    
    let list = app.tables.element(boundBy: 0).cells
    _ = list.element.waitForExistence(timeout: 7)
    guard list.count > 0 else {
      print("🚨 testAddRecipeToFavorite() passed without performing any task."
            + "\nReason: list is empty, no cell can be tapped 🚨")
      return
    }
    
    let numberOfAvailableIndices = list.count - 1
    var currentIndex = 0
    var isFavorite = false
    
    repeat {
      let row = list.element(boundBy: currentIndex)
      row.tap()
      isFavorite = app.navigationBars.buttons["bookmark.fill"].exists
      if currentIndex == numberOfAvailableIndices && isFavorite {
        app.navigationBars.buttons["bookmark.fill"].tap()
        let removalSnackbarMessage = app.staticTexts["Removed from Favorite"]
        _ = removalSnackbarMessage.waitForExistence(timeout: 2)
        break
      }
      if isFavorite {
        currentIndex += 1
        app.navigationBars.buttons.element(boundBy: 0).tap()
      }
    } while isFavorite
    
    app.navigationBars.buttons["bookmark"].tap()
    let snackBarMessage = app.staticTexts["Added to Favorite"]
    XCTAssert(snackBarMessage.exists)
    XCTAssert(app.navigationBars.buttons["bookmark.fill"].exists)
  }
  
  func testRemoveRecipeFromFavorite() {
    /**
     Skenario:
     1.   Ketuk tab Favorites untuk berpindah dari home
     2.   Apabila list kosong / belum pernah ditambahkan, panggil metode `addRecipeToFavoriteFromHome(app:)`
        terlebih dahulu untuk menambahkan satu recipe ke favorite
     3.   Ketuk cell pertama dari list
     4.   Ketuk tombol bookmark di pojok kanan atas (di trailing navigation bar)
        dan pastikan muncul pesan indikasi berhasil dihapus.
     5.   Pastikan tombol bookmark sekarang berganti icon
     */
    let app = XCUIApplication()
    app.launch()
    
    app.tabBars.buttons["Favorites"].tap()
    
    let list = app.tables.element(boundBy: 0).cells
    
    if list.count == 0 {
      addRecipeToFavoriteFromHome(app: app)
      app.navigationBars.buttons.element(boundBy: 0).tap()
      app.tabBars.buttons["Favorites"].tap()
    }
    
    let firstCell = list.element(boundBy: 0)
    firstCell.tap()
    
    app.navigationBars.buttons["bookmark.fill"].tap()
    let snackBarMessage = app.staticTexts["Removed from Favorite"]
    
    XCTAssert(snackBarMessage.exists)
    XCTAssert(app.navigationBars.buttons["bookmark"].exists)
  }
  
}
