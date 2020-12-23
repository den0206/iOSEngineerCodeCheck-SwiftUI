//
//  SearchViewModel.swift
//  iOSEngineerCodeCheck-SwiftUI
//
//  Created by 酒井ゆうき on 2020/12/22.
//

import Foundation
import SwiftUI

final class SearchViewModel : ObservableObject {
    
    @Published var searchWord : String = ""
    
    @Published var repositries = [Repositry]()
    @Published var currentPage : Int = 1
    @Published var reachLast = false
    
    @Published var showAlert = false
    @Published var alert : Alert = Alert(title: Text(""))
    
    
    var timer : Timer?
    
    //MARK: - functions

    /// API通信
    
    func resetSearch() {
        repositries = [Repositry]()
        reachLast = false
        currentPage = 1
    }
    
    func sendRequest() {
        
        guard Reachabilty.HasConnection() else {
            self.searchWord = ""
            errorAlert(message: "No Internet Connection")
            return
        }
        
        resetSearch()
      
        timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
            self.searchRepositry()
        })
    }
    
    
    func searchRepositry() {
        
        let baseUrl = "https://api.github.com/search/repositories?q=\(searchWord)&page=\(currentPage)&per_page=20"
        
        guard let url = URL(string: baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            errorAlert(message: "No URL")
            return
            
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, _, error) in
            
            if error != nil {
                self.errorAlert(message: error!.localizedDescription)
                return
            }
            
            guard let safeData = data else {
                self.errorAlert(message: "Can't func Data")
                return
            }
            
            let decorder = JSONDecoder()
            
            do {
                let decorderData = try decorder.decode(GithubSearchResult.self, from: safeData)
                
                if decorderData.items != nil {
                    
                    DispatchQueue.main.async {
                        
                        self.repositries.append(contentsOf: decorderData.items!)
                        self.timer?.invalidate()
                        
                        print(self.repositries.count)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.timer?.invalidate()
                        self.reachLast = true
                    }
                }
                
            } catch {
                self.timer?.invalidate()
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    //MARK: - Configure Error Alert
    private func errorAlert(message : String) {
        
        self.showAlert = true
        self.alert = Alert(title:Text("ERROR"), message: Text(message), dismissButton: .cancel(Text("OK")))
    }
    
    //MARK: - Pagination
    
    func readMore() {
        
        guard !reachLast else {return}
        
        /// pagenationの為の加算
        currentPage += 1
        searchRepositry()
    }
    
}
