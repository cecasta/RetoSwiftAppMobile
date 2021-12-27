//
//  AppViewModel.swift
//  RetoSophos
//
//  Created by ccastano on 26/12/21.
//

import SwiftUI
import LocalAuthentication
import FirebaseAuth

class AppViewModel: ObservableObject {
    let auth = Auth.auth()
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
/*    func signIn() {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            // Success
            DispatchQueue.main.async {
                self?.signedIn = true
            }
            
        }
    }
*/
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
        print(email == Stored_User)
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
            auth.signIn(withEmail: email, password: password) { (res, err) in
                if let error = err {
                    self.alertMsg = error.localizedDescription
                    self.alert.toggle()
                    print("error en sign")
                    return
                }
              
                // Else Goto Home...
               
                if self.Stored_User == "" || self.Stored_Password == "" {
                    self.store_Info.toggle()
                    return
                }
                
                DispatchQueue.main.async {
                    self.signedIn = true
                }
            }
    }

}
