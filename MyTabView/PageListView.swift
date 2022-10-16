//
//  PageListView.swift
//  MyTabView
//
//  Created by Shunji Sakaue on 2022/10/15.
//

import SwiftUI

struct PageListView: View {
    @State var timerHandler : Timer?
    @State var timerCounter = 0
    @State var arrayListData: [String] = []
    
    var body: some View {
        VStack{
            HStack {
                Button("Start") {
                    startBeaconTimer()
                }
                .foregroundColor(.blue)
                .font(.title)
                .frame(width: 130, height: 60, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 2)
                )
                Button("Stop") {
                    stopBeaconTimer()
                }
                .foregroundColor(.blue)
                .font(.title)
                .frame(width: 130, height: 60, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 2)
                )
            }
            List {
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            Text(String(timerCounter))
            
        }
    }
    func startBeaconTimer()
    {
        if let unwrapedTimerHandler = timerHandler {
            if unwrapedTimerHandler.isValid == true {
                return
            }
        }
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            checkBeaconTimer()
        }

    }

    func stopBeaconTimer()
    {
        if let unwrapedTimerHandler = timerHandler {
            if unwrapedTimerHandler.isValid == true {
                unwrapedTimerHandler.invalidate()
                return
            }
        }
    }
    
    func checkBeaconTimer()
    {
        timerCounter += 1
    }
}

struct PageListView_Previews: PreviewProvider {
    static var previews: some View {
        PageListView()
    }
}
