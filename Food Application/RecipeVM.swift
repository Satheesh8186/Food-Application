//
//  RecipeVM.swift
//  Food Application
//
//  Created by satheesh kumar on 12/06/23.
//

import Foundation
class RecipeVM:ObservableObject{
    @Published var recipe : [Recipe] = []
    
    func getRecipes() async throws{
        var request = URLRequest(url: URL(string: "https://food2fork.ca/api/recipe/search/?page=2&query=beef")!)
                request.addValue("Token 9c8b06d329136da358c2d00e76946b0111ce2c48", forHTTPHeaderField: "Authorization")
        let (data,response)  = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse,response.statusCode == 200 else {
            throw networkError.invalidResponse
        }
        do{
           let jsonDecode = JSONDecoder()
            let responseData = try jsonDecode.decode(RecipesModel.self, from: data)
            DispatchQueue.main.async {
                self.recipe = responseData.results
            }
            
        }catch{
            throw networkError.unableTodecode
        }

    }
}

enum networkError:Error{
    case invalidUrl
    case invalidResponse
    case unableTodecode
}
