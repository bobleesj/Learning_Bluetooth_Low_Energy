//
//  ViewController.swift
//  RunApp
//
//  Created by Bob Lee on 2/3/17.
//  Copyright © 2017 BobtheDeveloper. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
 
  // Create optional types
  var manager: CBCentralManager!
  var bluetoothPeripheral: CBPeripheral!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create a manager's object
    manager = CBCentralManager(delegate: self, queue: nil)
  }
  
  
  
  // Every time peripherals get discovered, this callback function runs. It returns as CBPeripheral object
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    print("Discovered \(peripheral.name)")
    
    self.bluetoothPeripheral = peripheral
    // If the connection is successful, it call a delegat method, didConnectPeripheral
    manager.connect(peripheral, options: nil)
    
    // One discovered, stop scanning
    manager.stopScan()
  }
  

  let UID = CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")
  let newUID = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("Peripheral Connected")
    bluetoothPeripheral = peripheral
    bluetoothPeripheral.delegate = self
    // peripheral.discoverServices([UID, newUID])
    
    // If you enter nil, you discover every service
    peripheral.discoverServices(nil)
    
    print("You are connected with, \(peripheral.name)")
    
    // Once connected, the peripheral calles the peripheral:didDiscoverSrevices of the delegate object and create an array of CBServices objects
  }
  
  
  // Check whether your phone turned bluetooth or not
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == .poweredOn {
      central.scanForPeripherals(withServices: nil, options: nil)
    } else {
      print("Bluetooth not available")
    }
    
  }
  
  
  // 1. Peripheral Object Finding Services
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    print("Trying to find out if there is any service")
    
    
  print("Your service is  \(String(describing: peripheral.services))")
    let services = peripheral.services
    peripheral.discoverCharacteristics(nil, for: services![0])
  }
  
  
  // 2. Peripheral Object Finding Characteristics
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
  
    
    for character: CBCharacteristic in service.characteristics! {
      print("Printing Characters: \(character)")
      if let value = character.value  {
        print("The value is \(value)")
      }
      
      print(character.uuid)
      print(character.properties)
      print(character.value)
      
    }
    
    let firstChrac = service.characteristics![0]
    let secondChrac = service.characteristics![1]
    
    // Effective for static value, not dynamic
    peripheral.readValue(for: firstChrac)
    peripheral.readValue(for: secondChrac)
    
    // Observe and Listen
    peripheral.setNotifyValue(true, for: firstChrac)
    peripheral.setNotifyValue(true, for: secondChrac)
    
    print("Characteristic of firstChract \(firstChrac)")
    
    
  }
  
  // When you read value, you call didUpdateValueForChracteristics
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    characteristic.value
  }
  
  
  
  
  // When you setNotifiyValue, it calls didUpdateNotification
  func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
    print("Character value has been updated")
  }
  
  // Writing Value along with Button
  @IBAction func writeValueButtonTapped(_ sender: UIButton) {
    
    if let firstChract = bluetoothPeripheral.services?[0].characteristics?[1] {
      
      let chracter: Character = "H"
      let stringData = "H".data(using: .utf8)
      
      // With response or without
      bluetoothPeripheral.writeValue(stringData!, for: firstChract, type: .withoutResponse
      
      // When a BLE peripheral advertises characteristics the advertisement includes the properties of those characteristics. These include what operations are supported on that characteristic - read, notify, write without response and write with response.
        
        
       //  In this case it seems that the characteristic supports write with response but not write without response, so when you attempt a write without response you get the warning and the write operations doesn't complete
      )
      
      
    }
    

  }
  
  
  
}
