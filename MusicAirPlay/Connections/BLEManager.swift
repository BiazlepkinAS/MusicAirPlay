import CoreBluetooth

class BLEManager {
    var centralManager: CBCentralManager!
    var bleHandler: BLEHandler
    
    init() {
        self.bleHandler = BLEHandler()
        self.centralManager = CBCentralManager(delegate: self.bleHandler, queue: nil)
    }
}

class BLEHandler: NSObject, CBCentralManagerDelegate {
    
    override init() {
        super.init()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .unsupported:
            print("BLE is not supported")
        case .unauthorized:
            print("BLE is not authorized")
        case .unknown:
            print("BLE is unknown")
        case .resetting:
            print("BLE is resetting")
        case .poweredOff:
            print("BLE is powered Off")
        case .poweredOn:
            print("BLE is powered ON")
            print("Start scanning")
            central.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("BLE default")
        }
    }
    
    func centralManager(central: CBCentralManager!,
                        didDescoverPeripheral peripheral: CBPeripheral!,
                        advertiSementData: [NSObject : AnyObject]!,
                        RSSI: NSNumber!) {
        print("\(peripheral.name) : \(RSSI) dBm)")
    }
}
