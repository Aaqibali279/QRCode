//
//  ScanQRCode.swift
//  QRCodeGenerator
//
//  Created by Aquib on 23/07/19.
//  Copyright © 2019 Aquib. All rights reserved.
//

import UIKit
class ScannerVC: UIViewController {
    
    @IBOutlet weak var scanner: QRCodeScannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanner.stop()
    }
}

extension ScannerVC:QRDelegate{
    func onQrSuccess(value: String) {
        print("CODE:",value)
        pop()
    }
    
    func onQrFailure(message: String) {
        print(message)
        pop()
    }
    
    private func pop(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true)
        }
    }
}
