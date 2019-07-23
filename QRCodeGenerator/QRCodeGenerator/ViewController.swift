//
//  ViewController.swift
//  QRCodeGenerator
//
//  Created by Aquib on 23/07/19.
//  Copyright © 2019 Aquib. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var iv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = generateQRCode(from: "this is the qr code")
        iv.image = image
        
        
        
    }
    
    @IBAction func scan(_ sender: UIButton) {
        let vc = ScannerViewController()
        present(vc, animated: true)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
   

}

