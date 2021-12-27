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
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width:150,height: 150)
            
            VStack {
                // input
                TextField("Correo Electrónico", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                // input
                SecureField("Contraseña", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                // button
                Button(action:{
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    loginModel.verifyUser(email: email, password: password)
                }, label: {
                    Text("Iniciar Sesión")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .background(Color.red)
                        .cornerRadius(8)
                })
                .opacity(email != "" && password != "" ? 1 : 0.5)
                .disabled(email != "" && password != "" ? false : true)
                .alert(isPresented: $loginModel.alert, content: {
                        Alert(title: Text("Error"), message: Text(loginModel.alertMsg), dismissButton: .destructive(Text("OK")))
                    })
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
                    .alert(isPresented: $loginModel.store_Info, content: {
                        Alert(title: Text("Mensaje"), message: Text("Quieres guardar usuario y contraseña????"), primaryButton:
                                    .default(Text("Aceptar"), action: {
                            // storing Info for Biometric....
                            loginModel.Stored_User = generalModel.email
                            loginModel.Stored_Password = generalModel.password
                            withAnimation{
                                loginModel.logged = true
                                self.generalModel.signedIn = true
                            }
                        }), secondaryButton: .cancel({
                            // redirecting to home
                            withAnimation{
                                loginModel.logged = true
                                self.generalModel.signedIn = true
                            }
                        }))
                    })
                
            }
            .padding()
        }
        .navigationTitle("Login")
    }
}
