//
//  Loadingview.swift
//  iOSEngineerCodeCheck-SwiftUI
//
//  Created by 酒井ゆうき on 2020/12/23.
//


import SwiftUI
import UIKit

extension View {

    func Loading(isShowing : Binding<Bool>, _ text : Text = Text("Loading...")) -> some View {
        LoadingView(isShowing: isShowing, presenting: {
            self
        }, text: text)
    }
}


struct LoadingView<Presenting> : View where Presenting : View {
    
    @Binding var  isShowing : Bool
    let presenting : () -> Presenting
    let text : Text
    
    var body: some View {
   
        return GeometryReader { geometry in
            
            ZStack(alignment: .center) {
                
                self.presenting()
                 .blur(radius: self.isShowing ? 1 : 0)

                /// black back
                if self.isShowing {

                    Color.primary.opacity(0.4)
                        .ignoresSafeArea(.all)
                }

                
                VStack(spacing :10) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    
                    self.text
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
//                .transition(.fade(duration: 0.5))
                .opacity(self.isShowing ? 1 : 0)
                
            }
            
        }
        
        
    }
    
}

