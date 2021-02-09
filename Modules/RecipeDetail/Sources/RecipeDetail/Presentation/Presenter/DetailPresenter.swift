//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 14/01/21.
//

import SwiftUI
import Core
import Combine
import Recipe

public class DetailPresenter<Request, Response, Interactor: DetailUseCase>: ObservableObject
where
  Interactor.Request == Request,
  Interactor.Response == Response {
  
  private var useCase: Interactor
  private var dataModelId: Request
  private var cancellables: Set<AnyCancellable> = []
  
  @Published public var dataModel: Response
  @Published public var dataModelIsInLocalDB: Bool = false
  @Published public var state: PresenterState = .populated
  
  public var onAddToLocalButtonClickedMessage: String {
    dataModelIsInLocalDB ? "Added to Favorite" : "Removed from Favorite"
  }
  
  public init(useCase: Interactor, dataModelId: Request) {
    self.useCase = useCase
    self.dataModelId = dataModelId
    self.dataModel = useCase.getRecipe()
  }
  
  public func fetchRecipe() {
    state = .loading
    useCase.execute(request: dataModelId)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          self?.state = .populated
        case .failure(let error):
          self?.state = .error(error.localizedDescription)
        }
      } receiveValue: { [weak self] value in
        self?.dataModel = value
      }
      .store(in: &cancellables)
  }
  
  public func onAddToLocalButtonClicked() {
    dataModelIsInLocalDB ? deleteDataModel() : saveDataModel()
  }
}


// MARK: - Create, Read, Delete Operations
extension DetailPresenter {
  public func saveDataModel() {
    useCase.addEntity(dataModel)
      .receive(on: DispatchQueue.main)
      .sink { _ in
        
      } receiveValue: { [weak self] success in
        if success {
          self?.dataModelIsInLocalDB = true
        }
      }
      .store(in: &cancellables)
  }
  
  public func deleteDataModel() {
    useCase.deleteEntity(byId: dataModelId)
      .receive(on: DispatchQueue.main)
      .sink { _ in
        
      } receiveValue: { [weak self] success in
        if success {
          self?.dataModelIsInLocalDB = false
        }
      }
      .store(in: &cancellables)
  }
  
  public func checkIsInLocalDB() {
    useCase.checkExistence(of: dataModel)
      .receive(on: DispatchQueue.main)
      .sink { _ in
        
      } receiveValue: { [unowned self] in
        self.dataModelIsInLocalDB = $0
      }
      .store(in: &cancellables)
  }
}
