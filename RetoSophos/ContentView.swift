//
//  ContentView.swift
//  RetoSophos
//
//  Created by ccastano on 21/12/21.
//

import SwiftUI



struct ContentView: View {
    @EnvironmentObject var generalViewModel: GeneralViewModel
    
    var body: some View {
        NavigationView {
            if generalViewModel.signedIn {
                Home()
                    .navigationTitle("Home")
                    .navigationBarHidden(false)
                    .preferredColorScheme(.light)
            }
            else {
                Login()
                    .preferredColorScheme(.dark)
                    .navigationBarHidden(true)
            }
        }
        .onAppear {
            generalViewModel.signedIn = generalViewModel.isSignedIn
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
