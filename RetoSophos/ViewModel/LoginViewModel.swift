//
//  LoginViewModel.swift
//  RetoSophos
//
//  Created by ccastano on 22/12/21.
//

import SwiftUI
import LocalAuthentication

class LoginViewModel : ObservableObject{
    @StateObject var GeneralModel = GeneralViewModel()
    

    // for message - alerts..
    @Published var alert = false
    @Published var alertMsg = ""
    
    @AppStorage("storage_User") var Storage_User = "STORED_EMAIL_ID"
    
    func signIn(email: String, password: String) {
        GeneralModel.auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            // Success
            DispatchQueue.main.async {
                self?.GeneralModel.signedIn = true
            }
        }
    }
    func signOut() {
        try? GeneralModel.auth.signOut()
        
        self.GeneralModel.signedIn = false
    }

    
  
    
    // getting biometricType
    
    func getBioMetricStatus()-> Bool{
        let scanner = LAContext()
        if GeneralModel.email == Storage_User &&
            scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none) {
                return true
        }
        return false
    }
    
    func authenticateUser(){
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Desbloquea tu \($GeneralModel.email)") {
            (status, err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            // setting logged status as true
            //withAnimation(.easeOut){logged = true}
        }
    }
}
