//
//  AuthViewModel.swift
//  PhoneAuthDemo
//
//  Created by khawlah khalid on 24/06/2022.
//

import Foundation
import Firebase


final class AuthViewModel : ObservableObject{
    @Published var verificationId : String? //the code that is sended by Firebase
    @Published var phoneNumber : String = ""
    @Published var smsCode: String = ""
    @Published var isShowingHomeView: Bool = false
    let auth = Auth.auth()
    
    
    func createAccountWithPhoneNumber(){
        let phoneNumber = "+966"+self.phoneNumber
        print(phoneNumber,"🔴")
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, error in
            if let error = error {
                print("Error while getting sms : \(error)")
                return
            }
            self.verificationId = verificationId
            print("DEBUG: phone has been registered successfully")
        }
    }
    
    
    func verifySMSCode(){
        DispatchQueue.main.async {
            guard let verificationId = self.verificationId else {return}
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: self.smsCode)
            
            self.auth.signIn(with: credential) { result, error in
                if let error = error {
                    print("Error: error while verifying sms code \(error)")
                    return
                }
                
                print("DEBUG: 6 - Successfully Uploaded user info to firebase with saved phone number")
                            guard let result = result else {
                                print("here")
                                return}
                            let userId = result.user.uid
                            let userData = [
                                "id": userId,
                                "phoneNumber": self.phoneNumber
                            ]
                            
                            Firestore.firestore().collection("users").document(userId).setData(userData)
                            self.isShowingHomeView.toggle()
            }
        }
    }
}
