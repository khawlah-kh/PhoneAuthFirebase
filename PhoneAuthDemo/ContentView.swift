//
//  ContentView.swift
//  PhoneAuthDemo
//
//  Created by khawlah khalid on 24/06/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Enter Phone Number", text: $authViewModel.phoneNumber)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.white, lineWidth: 0.5)
                    )
                    .padding()
                    .keyboardType(.numberPad)
                Button {
                    authViewModel.createAccountWithPhoneNumber()
                } label: {
                    Text("Create Account")
                }
                
                Divider()
                
                TextField("Enter OPT Code", text: $authViewModel.smsCode)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.white, lineWidth: 0.5)
                    )
                    .padding()
                    .keyboardType(.numberPad)
                
                Button {
                       authViewModel.verifySMSCode()
                } label: {
                    Text("Verify Code")
                }
                
                
                
                .navigationTitle("Phone Auth")
            }
            .fullScreenCover(isPresented: $authViewModel.isShowingHomeView) {
                Text("You are Good to go 😎")
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
