//
//  AppViewModel.swift
//  RetoSophos
//
//  Created by ccastano on 26/12/21.
//

import SwiftUI
import Foundation
import LocalAuthentication
import FirebaseAuth

class AppViewModel: ObservableObject {
    let auth = Auth.auth()
    let URL_BASE = "https://6w33tkx4f9.execute-api.us-east-1.amazonaws.com"
    @Published var client = ClientSophos(id: "", nombre: "", apellido: "", acceso: false, admin: false)
    @Published var signedIn = false
    @Published var email = ""
    @Published var password = ""
    // for message - alerts..
    @Published var alert = false
    @Published var alertMsg = ""
    @AppStorage("stored_User") var Stored_User = ""
    @AppStorage("stored_Password") var Stored_Password = ""
    @Published var store_Info = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            // Success
            DispatchQueue.main.async {
                self?.signedIn = false
            }
        }
    }
    
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false
    }
    
    // getting biometricType
    
    func getBioMetricStatus()-> Bool{
        let scanner = LAContext()
        if email == Stored_User &&
            scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none) {
            return true
        }
        return false
    }
    
    
    func authenticateUser(){
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Desbloquea tu \(email)") {
            (status, err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.signedIn = true
            }
            // test login desde biometria y password guardado
            self.password = self.Stored_Password
            self.verifyUser()
        }
    }
    
    func verifyUser(){

        
        let path = URL_BASE+"/RS_Usuarios?idUsuario="+email+"&clave="+password
        guard let url = URL(string: path) else {return}
        let search =  URLSession.shared.dataTask(with: url) { data,
            _, error in
            guard let data = data, error == nil else {
                return
            }
            // convert to User
            do {
                let userResponse = try JSONDecoder().decode(ClientSophos.self, from: data)

                
                if self.Stored_User == "" || self.Stored_Password == "" {
                    self.store_Info.toggle()
                    return
                }
                DispatchQueue.main.async {
                    self.client = userResponse
                    self.signedIn = true
                    print(userResponse)
                }
                
            }
            catch {
                print("se fue por error autenticacion sophos")
                DispatchQueue.main.async{
                    self.alertMsg = "Error autenticacón Sophos"
                    self.alert = true
                }
                
                print(error)
            }
            
        }
        search.resume()
        

    }
}
