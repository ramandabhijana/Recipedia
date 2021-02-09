//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 06/01/21.
//

import Foundation
import Core
import Combine

public class LocaleListPresenter<Request, Response, Interactor: ReactiveResponseUseCase>: ObservableObject, ListPresenterProtocol
where Interactor.Request == Request, Interactor.Response == [Response] {
  
  private var useCase: Interactor
  private var cancellables: Set<AnyCancellable> = []
  
  @Published public var list: [Response] = []
  @Published public var searchText: String = ""
  @Published public var state: PresenterState = .loading
  @Published public var isSearching: Bool = false
  
  public init(useCase: Interactor, request: Request) {
    self.useCase = useCase
    
    useCase.latestResponse
      .sink(receiveValue: onReceiveValue(list:))
      .store(in: &cancellables)
    
    $searchText
      .debounce(
        for: .seconds(0.7),
        scheduler: RunLoop.main
      )
      .map { text -> String? in
        text.count < 1 ? nil : text
      }
      .compactMap { $0 }
      .sink { _ in }
      .store(in: &cancellables)
  }
  
  public func getList(request: Request) {
    state = .loading
    useCase.execute(request: request)
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          switch completion {
          case .finished:
            break
          case .failure(let error):
            self?.state = .error(error.localizedDescription)
          }
        },
        receiveValue: onReceiveValue(list:)
      )
      .store(in: &cancellables)
  }
  
  private func onReceiveValue(list: [Response]) {
    guard !list.isEmpty else {
      self.state = .empty
      return
    }
    self.list = list
    self.state = .populated
  }
  
}

extension LocaleListPresenter {
  public func filteredRecipes() -> [Response]
  where Response == RecipeDomainModel {
    self.list.filter {
      searchText.isEmpty ||
        $0.title.lowercased().contains(searchText.lowercased())
    }
  }
}
