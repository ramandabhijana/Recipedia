//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 26/01/21.
//

import Foundation
import Core

public typealias ClassificationUseCase = Interactor<
  Data,
  ClassificationDomainModel,
  ClassificationRepository<
    ClassificationRemoteDataSource,
    ClassificationMapper
  >
>

public typealias GetClassificationPresenter = ClassificationPresenter<
  Data,
  ClassificationDomainModel,
  ClassificationUseCase
>
