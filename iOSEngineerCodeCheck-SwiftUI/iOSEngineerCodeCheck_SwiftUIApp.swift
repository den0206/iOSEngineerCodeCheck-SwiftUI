//
//  iOSEngineerCodeCheck_SwiftUIApp.swift
//  iOSEngineerCodeCheck-SwiftUI
//
//  Created by 酒井ゆうき on 2020/12/22.
//

import SwiftUI

@main
struct iOSEngineerCodeCheck_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            /// Root
           SearchView()
            .preferredColorScheme(.light)
        }
    }
}
