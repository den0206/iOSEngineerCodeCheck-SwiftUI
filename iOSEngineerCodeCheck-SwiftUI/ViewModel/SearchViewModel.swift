//
//  SearchViewModel.swift
//  iOSEngineerCodeCheck-SwiftUI
//
//  Created by 酒井ゆうき on 2020/12/22.
//

import Foundation

final class SearchViewModel : ObservableObject {
    
    @Published var searchWord : String = ""
    
    @Published var repositries = [Repositry]()
    @Published var currentPage : Int = 1
    @Published var reachLast = false
    
    var timer : Timer?
    
    //MARK: - functions

    /// API通信
    
    func resetSearch() {
        repositries = [Repositry]()
        reachLast = false
        currentPage = 1
    }
    
    func sendRequest() {
        
       resetSearch()
        
        timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
            self.searchRepositry()
        })
    }
    
    
    func searchRepositry() {
        
        let baseUrl = "https://api.github.com/search/repositories?q=\(searchWord)&page=\(currentPage)&per_page=20"
        
        guard let url = URL(string: baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {return}
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, _, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let safeData = data else {return}
            
            let decorder = JSONDecoder()
            
            do {
                let decorderData = try decorder.decode(GithubSearchResult.self, from: safeData)
                
                if decorderData.items != nil {
                    
                    DispatchQueue.main.async {
                        
                        self.repositries.append(contentsOf: decorderData.items!)
                        
                        print(self.repositries.count)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.reachLast = true
                    }
                }
                
            } catch {
                
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    //MARK: - Pagination
    
    func readMore() {
        
        guard !reachLast else {return}
        
        /// pagenationの為の加算
        currentPage += 1
        searchRepositry()
    }
    
}
