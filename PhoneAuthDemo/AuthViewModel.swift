//
//  AuthViewModel.swift
//  PhoneAuthDemo
//
//  Created by khawlah khalid on 24/06/2022.
//

import Foundation
import Firebase

final class AuthViewModel : ObservableObject{
    @Published var userSession : Firebase.User?
    @Published var verificationId : String? //the code that is sended by Firebase
    @Published var phoneNumber : String = ""
    @Published var smsCode: String = ""
    @Published var isAouthenticatting: Bool = false
    let auth = Auth.auth()
    init(){
        userSession = Auth.auth().currentUser
        if let _ = userSession {
            isAouthenticatting = true
        }
    }
    
    func createAccountWithPhoneNumber(){
        let phoneNumber = "+966"+self.phoneNumber
        //Will send the SMS message to the given phone number (in case no errors), and will return the same code in verificationId
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
                
                print("DEBUG: Successfully Uploaded user info to firebase with saved phone number")
                            guard let result = result else {
                                return}
                            let userId = result.user.uid
                            let userData = [
                                "id": userId,
                                "phoneNumber": self.phoneNumber
                            ]
                            
                            Firestore.firestore().collection("users").document(userId).setData(userData)
                            self.isAouthenticatting.toggle()
            }
        }
    }
}
