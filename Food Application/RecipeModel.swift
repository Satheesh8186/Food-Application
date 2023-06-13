//
//  RecipeModel.swift
//  Food Application
//
//  Created by satheesh kumar on 12/06/23.
//

import Foundation

struct RecipesModel: Decodable {
    let results: [Recipe]
}

struct Recipe: Decodable, Identifiable {
    
    let id: Int
    let title: String
    let featuredImage: URL
    
    private enum CodingKeys: String, CodingKey {
        case id = "pk"
        case title = "title"
        case featuredImage = "featured_image"
    }
    
}
