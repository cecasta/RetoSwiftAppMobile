//
//  ContentView.swift
//  RetoSophos
//
//  Created by ccastano on 21/12/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                VStack{
                    Text("Estas logueado")
                    Button(action: {
                        viewModel.signOut()
                    }, label: {Text("Cerrar sesión")
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .foregroundColor(Color.red)
                            .padding()
                    })
                }

            }
            else {
                Login()
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
