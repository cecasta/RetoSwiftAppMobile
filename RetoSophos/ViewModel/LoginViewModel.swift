//
//  LoginViewModel.swift
//  RetoSophos
//
//  Created by ccastano on 22/12/21.
//

import SwiftUI
import LocalAuthentication
import FirebaseAuth

class LoginViewModel : ObservableObject{
    let auth = Auth.auth()
    @StateObject var generalModel: GeneralViewModel = GeneralViewModel()
    @Published var email = ""
    @Published var password = ""

    // for message - alerts..
    @Published var alert = false
    @Published var alertMsg = ""
    // when firts time user logged in via email store this for future biometric login
    @AppStorage("stored_User") var Stored_User = ""
    @AppStorage("stored_Password") var Stored_Password = ""
    @AppStorage("status") var logged = false
    
    @Published var store_Info = false
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            // Success
            DispatchQueue.main.async {
                self?.generalModel.signedIn = true
            }
        }
    }
    func signOut() {
        try? auth.signOut()
        
        self.generalModel.signedIn = false
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
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Desbloquea tu \($email)") {
            (status, err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            // setting logged status as true
            //withAnimation(.easeOut){logged = true}
        }
    }
    
    func verifyUser(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { (res, err) in
            if let error = err {
                self.alertMsg = error.localizedDescription
                self.alert.toggle()
                print("error en sign")
                return
            }
            
            // ok
            if email == "" || password == "" {
                self.store_Info.toggle()
                print("error datos vacios")
                return
            }
            
            // Else Goto Home...
            withAnimation{
                self.logged = true
               
                print("enviar al home")
            }
            
        }
    }
}
