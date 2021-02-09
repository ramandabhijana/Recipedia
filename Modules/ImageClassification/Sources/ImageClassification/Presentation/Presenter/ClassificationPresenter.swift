//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 17/01/21.
//

import SwiftUI
import Combine
import Core

public class ClassificationPresenter<Request, Response, Interactor: UseCase>: ObservableObject
where
  Interactor.Request == Request,
  Interactor.Response == Response {
  
  private var useCase: Interactor
  private var cancellables: Set<AnyCancellable> = []
  
  @Published public var state: PresenterState = .empty
  @Published public var dataModel: Response?
  @Published public var image: UIImage? {
    didSet {
      guard
        let image = image,
        let data = image.jpegData(compressionQuality: 0.5),
        let request = data as? Request
      else {
        print("Couldn't get jpeg representation of UIImage")
        return
      }
      execute(request: request)
    }
  }
  
  public init(useCase: Interactor) {
    self.useCase = useCase
  }
  
  public func invalidate() {
    cancellables.dispose()
  }
  
  public func execute(request: Request) {
    state = .loading
    useCase.execute(request: request)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] result in
        switch result {
        case .failure(let error):
          print(error)
          self?.state = .error(error.localizedDescription)
        case .finished:
          break
        }
      } receiveValue: { [weak self] response in
        self?.dataModel = response
        self?.state = .populated
      }
      .store(in: &cancellables)
  }
}
