//
//  RecipeDetailView+Instructions.swift
//  Recipedia
//
//  Created by Abhijana Agung Ramanda on 14/11/20.
//

import SwiftUI
import Recipe

extension RecipeDetailView {
  var instructionsView: some View {
    ForEach(
      presenter.dataModel.instructions,
      id: \.number
    ) {
      InstructionRow<InstructionMiscView>(
        instruction: $0,
        goToDestination: { type, source in
          let useCase = InstructionMiscInteractor(
            dataSourceType: type,
            list: source
          )
          return InstructionMiscView(
            presenter: GetInstructionMiscPresenter(useCase: useCase)
          )
        }
      )
      Divider()
    }
  }
  
  struct InstructionRow<Destination: View>: View {
    @State private var showIngredients = false
    @State private var showEquipments = false
    
    private let goToDestination: (
      InstructionMiscDataSourceType, [InstructionMisc]
    ) -> Destination
    private let instruction: RecipeDomainModel.Instruction
    
    internal init(
      instruction: RecipeDomainModel.Instruction,
      goToDestination: @escaping (
        InstructionMiscDataSourceType, [InstructionMisc]
      ) -> Destination
    ) {
      self.goToDestination = goToDestination
      self.instruction = instruction
    }
    
    var ingredientsButton: some View {
      Button(
        action: { showIngredients.toggle() },
        label: { Text("Ingredients") }
      )
      .sheet(
        isPresented: $showIngredients
      ) {
        goToDestination(
          .ingredients,
          instruction.ingredients.map {
            InstructionMisc(
              identifier: $0.id,
              image: $0.imageURL,
              name: $0.name
            )
          }
        )
      }
    }
    
    var equipmentsButton: some View {
      Button(
        action: { showEquipments.toggle() },
        label: { Text("Equipments") }
      )
      .sheet(
        isPresented: $showEquipments
      ) {
        self.goToDestination(
          .equipments,
          instruction.equipments.map {
            InstructionMisc(
              identifier: $0.id,
              image: $0.imageURL,
              name: $0.name
            )
          }
        )
      }
    }
    
    var body: some View {
      HStack(alignment: .top) {
          Text("\(instruction.number)")
            .foregroundColor(Color.gray.opacity(0.2))
            .font(
              .system(size: 60, weight: .bold)
            )
            .padding(.trailing, 4)
          VStack(alignment: .leading, spacing: 8) {
            Text(instruction.description)
              .foregroundColor(.black)
            HStack(spacing: 30) {
              if !instruction.ingredients.isEmpty {
                ingredientsButton
              }
              if !instruction.equipments.isEmpty {
                equipmentsButton
              }
            }
            .foregroundColor(Color(#colorLiteral(red: 0.0431372549, green: 0.5176470588, blue: 0.3411764706, alpha: 1)))
            .font(.subheadline)
          }
      }
      .padding(.vertical, 8)
    }
    
  }
  
}
