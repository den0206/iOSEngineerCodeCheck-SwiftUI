//
//  DetailView.swift
//  iOSEngineerCodeCheck-SwiftUI
//
//  Created by 酒井ゆうき on 2020/12/22.
//

import SwiftUI
import SDWebImageSwiftUI


struct DetailView: View {
    
    var repo : Repositry
    
    var body: some View {
        
        VStack(spacing :10) {
            WebImage(url: URL(string: repo.owner.avatarURL))
                .resizable()
                .scaledToFit()
                .frame( height: 300)

            Text("\(repo.owner.login) / \(repo.name)")
                .font(.title)
                .padding(.vertical,10)

            HStack {
                VStack(alignment: .leading){
                    Text( "Written in \(repo.language ?? "")")
                        .font(.system(size: 14, weight : .bold))

                    Spacer()
                }

                Spacer()

                VStack(alignment: .leading, spacing: 8) {

                    Group {
                        Text("\(repo.starCount ?? 0) stars")
                        Text("\(repo.wacherscount ?? 0) watchers")
                        Text("\(repo.forksCount ?? 0) forks")
                        Text("\(repo.issuesCount ?? 0) open issues")
                    }
                    .font(.system(size: 14))


                    Spacer()
                }
            }
            .padding(.horizontal,10)

            Spacer()
        }
        .padding(.top,8)
        .foregroundColor(.primary)
    }
}
