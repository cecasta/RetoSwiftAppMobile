//
//  Login.swift
//  RetoSophos
//
//  Created by ccastano on 26/12/21.
//

import SwiftUI
import LocalAuthentication

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var isTouchIdValid: Bool = false
    
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
                    
                    HStack {
                        Spacer()
                        Button(action:{
                            guard !email.isEmpty, !password.isEmpty else {
                                return
                            }
                            viewModel.signIn(email: email, password: password)
                        }, label: {
                            Text("Login")
                                .foregroundColor(Color.white)
                                .frame(width: 200, height: 50)
                                .background(Color.red)
                                .cornerRadius(8)
                        })
                        .opacity(email != "" && password != "" ? 1 : 0.5)
                        .disabled(email != "" && password != "" ? false : true)
                        Spacer()

                        TouchIDButton(isValid: $isTouchIdValid)
                    }
                    NavigationLink("Crear cuenta", destination: CreateAccount())
                        .padding()
                    
                }
                .padding()
            }
            .navigationTitle("Login")
    }
}

