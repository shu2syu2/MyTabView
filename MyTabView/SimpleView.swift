//
//  SimpleView.swift
//  MyTabView
//
//  Created by S.S on 2022/10/23.
//

import SwiftUI
import Combine
import CoreLocation

struct BeaconReceiveInfo {
    var uuid:String;
    var major:NSNumber;
    var minor:NSNumber;
    var rssi:NSInteger;
    var time:Date;
}

class BeaconDetector: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var didChange = PassthroughSubject<Void, Never>()
    var locationManager: CLLocationManager?
    var lastDistance = CLProximity.unknown
    var isMontorEnable = false
    //var uuidstr = "D546DF97-4757-47EF-BE09-3E2DCBDD0C77"
    var uuidstr = "48534442-4C45-4144-80C0-1800FFFFFFFF"
    //var uuidstr = "AAAAAAAA-BBBB-CCCC-DDDD-FFFFFFFFFFFF"

    @Published var beaconReceives = [BeaconReceiveInfo]()
    @Published var receivedCont = 0
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        // アプリの使用中に位置情報サービスを使用するユーザーの許可を要求
        locationManager?.requestWhenInUseAuthorization()
        // アプリが使用中かどうかに関係なく、位置情報サービスを使用するユーザーの許可を要求
        //locationManager?.requestAlwaysAuthorization()
    }
    
    // didChangeAuthorization:アプリへの位置情報の許可状況が変化した時
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization state : CLAuthorizationStatus) {
        // notDetermined       未選択
        // restricted          位置情報サービスを使用する権限がありません
        // denied              拒否か無効
        // authorizedAlways    ユーザーはいつでも自分の位置情報を使用する権限を付与(background?)
        // authorizedWhenInUse アプリを使用している間のみ位置情報を使用する権限を付与
        if state == .authorizedAlways || state == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                // iBeacon 監視サポート中
                if CLLocationManager.isRangingAvailable() {
                    isMontorEnable = true
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        
        print("INFO: didRange ", beacons.count)
        for data in beacons {
            print("INFO: maj:min ", data.major, ":", data.minor, ", rssi = ", data.rssi)
            let beaconReceive = BeaconReceiveInfo(uuid: uuidstr, major:data.major, minor: data.minor, rssi: data.rssi, time: Date())
            update(beacon:beaconReceive)
        }
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {

        print("INFO: didRangeBeacons ", beacons.count)
        for data in beacons {
            print("INFO: maj:min ", data.major, ":", data.minor, ", rssi = ", data.rssi)
            print("INFO: maj:min ", data.major, ":", data.minor, ", rssi = ", data.rssi)
            let beaconReceive = BeaconReceiveInfo(uuid: uuidstr, major:data.major, minor: data.minor, rssi: data.rssi, time: Date())
            update(beacon:beaconReceive)
        }
    }

    // ビーコン領域の観測を開始
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("INFO: didStartMonitoringFor", region)
    }
    
    // 領域内にいるか判定
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        if (state == .inside) {
            print("didDetermineState : inside")
        }
        else if (state == .outside) {
            print("didDetermineState : outside")
        }
        else if (state == .unknown) {
            print("didDetermineState : unknown")
        }
    }
    // スキャン開始 or 停止
    func startStopScanning(isStart : Bool) {
        let uuid = UUID(uuidString: uuidstr)!
        let constraint = CLBeaconIdentityConstraint(uuid: uuid)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: uuid.uuidString)
        
        if isStart {
            receivedCont = 0
            beaconReceives = [BeaconReceiveInfo]()
            locationManager?.startMonitoring(for: beaconRegion)
            locationManager?.startRangingBeacons(satisfying: constraint)
        } else {
            locationManager?.stopMonitoring(for: beaconRegion)
            locationManager?.stopRangingBeacons(satisfying: constraint)
        }
    }
    func startScanning() -> Bool {
        if isMontorEnable == false {
            return false
        }
        startStopScanning(isStart:true)
        return true
    }
    func stopScanning() -> Bool {
        startStopScanning(isStart:false)
        return true
    }
    func update(beacon : BeaconReceiveInfo) {
        beaconReceives.append((beacon))
        receivedCont += 1
        didChange.send(())
    }
}

struct SimpleView: View {
    @ObservedObject var detector = BeaconDetector()
    @State var isStart: Bool = false
    var oldCount = 0
    var body: some View {
        VStack {
            HStack {
                Text("カウント:")
                Text(String(detector.receivedCont))
                    .frame(alignment: .trailing)
            }
            HStack {
                Button("Start") {
                    isStart = detector.startScanning()
                }
                .foregroundColor(.blue)
                .font(.title)
                .frame(width: 130, height: 60, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .disabled(isStart)
                
                Button("Stop") {
                    isStart = !detector.stopScanning()
	            }
                .foregroundColor(.blue)
                .font(.title)
                .frame(width: 130, height: 60, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .disabled(!isStart)
            }
            
            List {
                if detector.receivedCont == 0 {
                    
                    
                }
                else {
                    let listData =  detector.beaconReceives
                    ForEach(0 ..< listData.count, id: \.self) { index in
                        Text(detector.beaconReceives[index].uuid)
                    }
                }
            }
            Spacer()
        }
        
    }
}

struct SimpleView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleView()
    }
}
