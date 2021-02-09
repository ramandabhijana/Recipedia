//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 14/01/21.
//

import Foundation

public class InstructionMiscPresenter<Request, Response, Interactor: InstructionMiscUseCase>
where
  Interactor.Request == Request,
  Interactor.Response == Response {
  
  private let useCase: Interactor
  
  public init(useCase: Interactor) {
    self.useCase = useCase
  }
  
  public var listTitle: String { useCase.title }
  
  public func getList() -> [Response] { useCase.list }
}
