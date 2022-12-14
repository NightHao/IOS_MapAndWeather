//
//  LoginView.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/7.
//

import SwiftUI
import FacebookLogin
struct LoginView: View {
    let manager = LoginManager()
    var body: some View {
        if let accessToken = AccessToken.current,
                   !accessToken.isExpired {
            NavigationLink{
                ContentView()
            }label: {
                Text("開始使用")
            }
            Button{
                manager.logOut()
            }label: {
                Text("登出")
            }
                } else {
                    Button {
                        manager.logIn { result in
                            switch result {
                            case .success(granted: let granted, declined: let declined, token: let token):
                                print("success")
                            case .cancelled:
                                print("cancelled")
                            case .failed(_):
                                print("failed")
                            }
                        }
                    } label: {
                        Text("登入")
                    }
                }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
