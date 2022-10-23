//
//  PageSettingView.swift
//  MyTabView
//
//  Created by S.S on 2022/10/15.
//

import SwiftUI

struct PageSettingView: View {
    @State var txtIpAddress = ""
    @State var nPort = ""
    @State var txtUserName = ""
    var body: some View {
        NavigationView {
            Form {
                Text("Ip Address :")
                TextField("xxx.xxx.xxx.xxx", text: $txtIpAddress)
                Spacer()
                Text("Port :")
                TextField("443", text: $nPort)
                Spacer()
                Text("User Name :")
                TextField("User001", text: $txtUserName)
            }
            .navigationBarTitle("Setting")
        }
    }
}

struct PageSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PageSettingView()
    }
}
