//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 06/01/21.
//

import Foundation
import Core
import Combine

public class RemoteListPresenter<Request, Response, Interactor: RemoteUseCase>: ObservableObject, ListPresenterProtocol
where
  Interactor.Request == Request,
  Interactor.Response == [Response],
  Interactor.Status == NetworkStatus {
  
  private var request: Request
  private var useCase: Interactor
  private var cancellables: Set<AnyCancellable> = []
  
  public var networkStatusMessage = ""
  
  @Published public var list: [Response] = []
  @Published public var isLoadingData = false
  @Published public var state: PresenterState = .loading
  @Published public var isSearching = false
  @Published public var canLoadMoreData = true
  @Published public var showingNetworkStatusMessage = false
  
  public init(useCase: Interactor, request: Request) {
    self.useCase = useCase
    self.request = request
    self.getList(request: request)
    self.useCase
      .getCurrentNetworkStatus()
      .dropFirst()
      .sink { [weak self] status in
        guard let self = self else { return }
        switch status {
        case .online:
          if self.list.isEmpty { self.getList(request: self.request) }
          fallthrough
        case .offline:
          print(status.rawValue)
          self.showingNetworkStatusMessage = true
          self.networkStatusMessage = self.networkStatusMessage(for: status)
        default:
          break
        }
      }
      .store(in: &cancellables)
  }
  
  public func getList(request: Request) {
    useCase.execute(request: request)
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self?.state = .error(error.localizedDescription)
        }
      } receiveValue: { [weak self] list in
        guard !list.isEmpty else {
          self?.state = .empty
          return
        }
        self?.list += list
        self?.state = .populated
        self?.canLoadMoreData = list.count == 10
        self?.isLoadingData = false
      }
      .store(in: &cancellables)
  }
  
  public func loadMoreContentIfNeeded() {
    guard !isLoadingData && canLoadMoreData else { return }
    isLoadingData = true
    getList(request: self.request)
  }
  
  public func setRequest(_ request: Request) {
    self.request = request
    list.removeAll()
    state = .loading
    getList(request: request)
  }
  
  private func networkStatusMessage(for status: NetworkStatus) -> String {
    switch status {
    case .online: return "Back online 🚀"
    default: return "You're offline. 😭"
    }
  }
  
}
