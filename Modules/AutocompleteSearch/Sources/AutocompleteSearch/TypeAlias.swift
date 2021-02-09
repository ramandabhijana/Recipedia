//
//  File.swift
//  
//
//  Created by Abhijana Agung Ramanda on 26/01/21.
//

import Foundation
import class Core.Interactor

public typealias AutocompleteUseCase = Interactor<
  String,
  [AutocompleteDomainModel],
  AutocompleteRepository<
    AutocompleteRemoteDataSource,
    AutocompleteMapper
  >
>

public typealias GetAutocompletePresenter = AutocompletePresenter<
  String,
  AutocompleteDomainModel,
  AutocompleteUseCase
>
