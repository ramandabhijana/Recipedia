//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 15/01/21.
//

import Foundation
import SwiftUI
import Combine
import Core

public class AutocompletePresenter<Request, Response, Interactor: UseCase>: ObservableObject
where
  Interactor.Request == Request,
  Interactor.Response == [Response] {
  
  private var useCase: Interactor
  private var cancellables: Set<AnyCancellable> = []
  
  @Published public var searchText: String = ""
  @Published public var isSearching: Bool = false 
  @Published public var state: PresenterState = .empty
  @Published public var list: [Response] = []
  
  public init(useCase: Interactor) {
    self.useCase = useCase
    $searchText
      .debounce(
        for: .seconds(0.7),
        scheduler: DispatchQueue.main
      )
      .map { text -> String? in
        text.count < 1 ? nil : text
      }
      .compactMap { $0 as? Request }
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .failure(let error):
            print(error)
          case .finished:
            break
          }
        },
        receiveValue: execute(request:)
      )
      .store(in: &cancellables)
  }
  
  public func execute(request: Request) {
    state = .loading
    useCase.execute(request: request)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] result in
        switch result {
        case .failure(let error):
          self?.state = .error(error.localizedDescription)
        case .finished:
          break
        }
      } receiveValue: { [weak self] response in
        guard !response.isEmpty else {
          self?.state = .empty
          return
        }
        self?.list = response
        self?.state = .populated
      }
      .store(in: &cancellables)
  }
}
