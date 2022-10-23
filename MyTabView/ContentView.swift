//
//  ContentView.swift
//  MyTabView
//
//  Created by S.S on 2022/10/15.
//

import SwiftUI

struct ContentView: View {
    @State var Selection = 1
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            PageListView()
                .tabItem {
                    Label("List", systemImage: "1.circle")
                }
                .tag(1)
            PageGraphView()
                .tabItem{
                    Label("graph", systemImage: "2.circle")
                }
                .tag(2)
            PageSettingView()
                .tabItem{
                    Label("setting", systemImage: "3.circle")
                }
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
