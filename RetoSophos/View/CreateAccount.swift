//
//  CreateAccount.swift
//  RetoSophos
//
//  Created by ccastano on 26/12/21.
//

import SwiftUI

struct CreateAccount: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width:150,height: 150)
                
                VStack {
                    TextField("Correo Electrónico", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    SecureField("Contraseña", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    Button(action:{
                        guard !email.isEmpty, !password.isEmpty else {
                            return
                        }
                        viewModel.signUp(email: email, password: password)
                    }, label: {
                        Text("Crear cuenta")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50)
                            .background(Color.red)
                            .cornerRadius(8)
                    })

                }
                .padding()

                Spacer()
            }
            .navigationTitle("Crear cuenta")
    }
}
