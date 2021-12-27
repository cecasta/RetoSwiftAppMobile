//
//  Login.swift
//  RetoSophos
//
//  Created by ccastano on 26/12/21.
//

import SwiftUI
import LocalAuthentication

struct Login: View {
    //@State private var email = ""
    //@State private var password = ""
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var isTouchIdValid: Bool = false
    
    // when firts time user logged in via email store this for future biometric login
    @AppStorage("stored_User") var Stored_User = ""
    @AppStorage("stored_Password") var Stored_Password = ""
    
    
    //@Published var store_Info = false
    
    var body: some View {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width:150,height: 150)
                
                VStack {
                    TextField("Correo Electrónico", text: $viewModel.email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    
                    SecureField("Contraseña", text: $viewModel.password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    
                    HStack {
                        Spacer()
                        Button(action:{
                            guard !viewModel.email.isEmpty, !viewModel.password.isEmpty else {
                                return
                            }
                            viewModel.verifyUser()
                        }, label: {
                            Text("Login")
                                .foregroundColor(Color.white)
                                .frame(width: 200, height: 50)
                                .background(Color.red)
                                .cornerRadius(8)
                        })
                            .opacity(viewModel.email != "" && viewModel.password != "" ? 1 : 0.5)
                            .disabled(viewModel.email != "" && viewModel.password != "" ? false : true)

                        Spacer()
                        if viewModel.getBioMetricStatus() {
                            TouchIDButton(isValid: $isTouchIdValid)
                        }
                    }
                    Spacer()
                    if viewModel.alert {
                        Text(viewModel.alertMsg)
                    }
                    NavigationLink("Crear cuenta", destination: CreateAccount())
                        .padding()

                    
                }
                .padding()
                .alert(isPresented: $viewModel.store_Info, content: {
                    Alert(title: Text("Mensaje"), message: Text("Quieres guardar usuario y contraseña????"), primaryButton:
                                .default(Text("Aceptar"), action: {
                        // storing Info for Biometric....
                        Stored_User = viewModel.email
                        Stored_Password = viewModel.password
                        withAnimation{
                            self.viewModel.signedIn = true
                        }
                    }), secondaryButton: .cancel({
                        // redirecting to home
                        withAnimation{
                            self.viewModel.signedIn = true
                        }
                    }))
                })
            }
            .navigationTitle("Login")
    }
}

