//
//  Login.swift
//  RetoSophos
//
//  Created by ccastano on 22/12/21.
//

import SwiftUI
import LocalAuthentication

struct Login: View {
    @StateObject var loginModel = LoginViewModel()
    @StateObject var generalModel = GeneralViewModel()
    // when firts time user logged in via email store this for future biometric login
    @AppStorage("storage_User") var user = "STORED_EMAIL_ID"
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width:150,height: 150)
            
            VStack {
                // input
                TextField("Correo Electrónico", text: $generalModel.email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                // input
                SecureField("Contraseña", text: $generalModel.password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                // button
                Button(action:{
                    guard !generalModel.email.isEmpty, !generalModel.password.isEmpty else {
                        return
                    }
                    loginModel.signIn(email: generalModel.email, password: generalModel.password)
                }, label: {
                    Text("Iniciar Sesión")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .background(Color.red)
                        .cornerRadius(8)
                })
                    .opacity(generalModel.email != "" && generalModel.password != "" ? 1 : 0.5)
                    .disabled(generalModel.email != "" && generalModel.password != "" ? false : true)
                // button biometric faceID
                if loginModel.getBioMetricStatus() {
                    Button(action: loginModel.authenticateUser, label: {
                        Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color("green"))
                            .clipShape(Circle())
                    })
                }
                // link
                NavigationLink("Crear cuenta", destination: CreateAccount())
                    .padding()
                
            }
            .padding()
        }
        .navigationTitle("Login")
    }
}
