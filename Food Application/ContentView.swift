//
//  ContentView.swift
//  Food Application
//
//  Created by satheesh kumar on 12/06/23.
//

import SwiftUI
enum SortDirection {
    case asc
    case desc
}
struct ContentView: View {
    @State private var search: String = ""
    @StateObject private var vm = RecipeVM()
    @State private var filteredRecipes: [Recipe] = []
    @State private var sortDirection: SortDirection = .asc
    private func performSearch(keyword:String){
        filteredRecipes = vm.recipe.filter { recipe in
            recipe.title.contains(keyword)
        }
    }
    private var recipes: [Recipe] {
        filteredRecipes.isEmpty ? vm.recipe: filteredRecipes
    }
    
    var sortDirectionText: String {
        sortDirection == .asc ? "Sort Descending": "Sort Ascending"
    }
    
    private func performSort(sortDirection: SortDirection) {
        
        var sortedRecipes = recipes
        
        switch sortDirection {
        case .asc:
            sortedRecipes.sort { lhs, rhs in
                lhs.title < rhs.title
            }
        case .desc:
            sortedRecipes.sort { lhs, rhs in
                lhs.title > rhs.title
            }
        }
        
        if filteredRecipes.isEmpty {
            vm.recipe = sortedRecipes
        } else {
            filteredRecipes = sortedRecipes
        }
        
    }
    var body: some View {
        NavigationStack{
            VStack {
                Button(sortDirectionText) {
                    sortDirection = sortDirection == .asc ? .desc: .asc
                }
                List(recipes){ recipe in
                    HStack {
                        AsyncImage(url: recipe.featuredImage) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 100, maxHeight: 100)
                        } placeholder: {
                            Text("Loading...")
                        }
                        Text(recipe.title)
                    }.searchable(text: $search)
                        .onChange(of: search, perform: performSearch)
                        .onChange(of: sortDirection, perform: performSort)
                    
                }.task {
                    do {
                        try await vm.getRecipes()
                    } catch {
                        print(error)
                    }
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
