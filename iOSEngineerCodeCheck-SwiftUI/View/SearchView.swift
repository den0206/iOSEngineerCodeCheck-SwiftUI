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
            GeometryReader { geo in
                
                ScrollView {
                    
                    /// Search Bar
                    
                    SearchBar(searchText: $vm.searchWord)
                        .autocapitalization(.none)
                        .padding(.top,7)
                        .onChange(of: vm.searchWord, perform: { _ in
                
                            if vm.searchWord == "" {
                                vm.resetSearch()
                            } else {
                                /// Call API
                                vm.sendRequest()
                            }
                        })
                        .alert(isPresented: $vm.showAlert, content: {
                            vm.alert
                        })
                    
                    /// Search Result

                    switch vm.repositries.count {
                    
                    case 0 :
                        Text("検索結果がありません").frame(width: geo.size.width, height: geo.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    default:
                        LazyVStack {
                            ForEach(0 ..< vm.repositries.count, id : \.self) { i in
                                
                                NavigationLink(
                                    destination: DetailView(repo: vm.repositries[i]),
                                    label: {
                                        
                                        /// Repositry Cell
                                        if i != self.vm.repositries.count - 1 {
                                            RepositryCell(repo: vm.repositries[i])
                                        } else {
                                            RepositryCell(repo: vm.repositries[i])
                                                .onAppear {
                                                    /// pagination
                                                    vm.readMore()
                                                }
                                        }
                                    })
                            }
                        }
                    }
                
                }
            }
      
            .navigationBarTitle("Search Repositry")
            .navigationBarTitleDisplayMode(.inline)
        }
        .Loading(isShowing: $vm.loading)
       
        
    }
}

//MARK: - Repositry Cell

struct RepositryCell : View  {
    var repo : Repositry
    
    var body: some View {
        VStack(alignment: .leading){
            Spacer()
            
            Text(repo.fullName)
                .font(.system(size: 14))
                .foregroundColor(.primary)
            
            Spacer()
            Divider()
        }
        .frame(height: 60)
        .padding(.horizontal,12)

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
        SearchBar(searchText: .constant(""))
    }
}
