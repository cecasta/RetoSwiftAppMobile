//
//  Home.swift
//  RetoSophos
//
//  Created by ccastano on 23/12/21.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        VStack{
            Text("Estas logueado............")
                .navigationTitle("Home")
                .navigationBarHidden(false)
                .preferredColorScheme(.light)
            
            Button(action: {
                viewLoginModel.signOut()
            }, label: {Text("Cerrar sesión")
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .foregroundColor(Color.red)
                    .padding()
            })
        }
        
    }
}

