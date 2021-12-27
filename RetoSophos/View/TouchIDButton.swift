//
//  TouchIDButton.swift
//  RetoSophos
//
//  Created by ccastano on 26/12/21.
//

import SwiftUI

import LocalAuthentication

struct TouchIDButton: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Binding var isValid: Bool
    var reason: String = "TouchId authentication needed!"
    
    var body: some View {
        Button(action: viewModel.authenticateUser /*verify*/, label: {
            Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                .font(.title)
                .foregroundColor(.red)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
        })
    }
    
    private func verify() {
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.reason) { (success, error) in
                
                DispatchQueue.main.async {
                    self.isValid = success
                    self.viewModel.signedIn = true
                    print("verify OK")
                }
            }
            
        }
    }
}

struct TouchIDButton_Previews: PreviewProvider {
    static var previews: some View {
        TouchIDButton(isValid: .constant(true))
    }
}
