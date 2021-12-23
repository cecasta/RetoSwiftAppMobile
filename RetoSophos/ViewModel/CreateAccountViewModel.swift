//
//  CreateAccountViewModel.swift
//  RetoSophos
//
//  Created by ccastano on 22/12/21.
//

import SwiftUI

class CreateAccountViewModel : ObservableObject{
    @StateObject var GeneralModel = GeneralViewModel()
    
    func signUp(email: String, password: String) {
        GeneralModel.auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            // Success
            DispatchQueue.main.async {
                self?.GeneralModel.signedIn = false
            }
        }
    }

}
