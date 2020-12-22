//
//  SearchView.swift
//  iOSEngineerCodeCheck-SwiftUI
//
//  Created by 酒井ゆうき on 2020/12/22.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var vm = SearchViewModel()
    
    var body: some View {
       
        NavigationView {
            
            ScrollView {
                SearchBar(searchText: $vm.searchWord)
                    .autocapitalization(.none)
                    .padding(.top,7)
                    .onChange(of: vm.searchWord, perform: { text in
                        /// Call API
                        vm.sendRequest()
                        
                        if text == "" {
                            vm.resetSearch()
                        }
                    })
                
                LazyVStack {
                    ForEach(0 ..< vm.repositries.count, id : \.self) { i in
                        
                        /// Repositry Cell
                        RepositryCell(repo: vm.repositries[i])
                    }
                }
                
                
            }
            .padding(.horizontal,12)
            
            .navigationBarTitle("Search Repositry")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//MARK: - Repositry Cell

struct RepositryCell : View  {
    var repo : Repositry
    
    var body: some View {
        VStack(alignment: .leading){
            Text(repo.fullName)
                .font(.system(size: 14))
                .foregroundColor(.primary)
            
            Divider()
        }
    }
}

//MARK: - Search Bar
struct SearchBar : View {
    
    @Binding var searchText : String
    @State private var isSearching = false
    
    var body: some View {
        
        
        HStack {
            HStack {
                TextField("Search", text: $searchText)
                    .padding(.leading,24)
                    .onTapGesture(perform: {
                        self.isSearching = true
                    })
            }
            .padding()
            .background(Color(.systemGray3))
            .cornerRadius(12)
            .padding(.horizontal)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    Spacer()
                    
                    if isSearching {
                        Button(action: {
                            self.searchText = ""
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.vertical)
                        })
                    }
                }
                .padding(.horizontal,32)
                .foregroundColor(.gray)
            )
            .transition(.move(edge: .trailing))
            .animation(.spring())
            
            
            if isSearching {
                Button(action: {
                    isSearching = false
                    searchText = ""
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.gray)
                })
                .padding(.trailing,24)
                .padding(.leading,0)
                .transition(.move(edge: .trailing))
                .animation(.spring())
            }
        }
    
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
