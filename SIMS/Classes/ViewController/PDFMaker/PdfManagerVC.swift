//
//  PdfManager.swift
//  SIMS
//  
//  Created by Mohd Danish Khan  on 20/04/19.
//  Copyright © 2019 Mohd Danish Khan. All rights reserved.
//

import UIKit
import PDFKit
                                                                       
class PdfManagerVC: UIViewController {

    var filePath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.previewPDF()
        self.alertUtil(title: "Downloaded", message: "Inventory Data file is downloaded and saved in mobile. At Location: \\n \(filePath)")
    }
    
    func previewPDF() {
        //if filepath is empty string
        if (self.filePath.count == 0) {
            return
        }
        let pdfView = PDFView(frame: view.bounds)
        pdfView.autoScales = true
        view.addSubview(pdfView)
        
        let pdfDocument = PDFDocument(url: URL(fileURLWithPath: filePath))!
        pdfView.document = pdfDocument
    }
    
    func alertUtil(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func viewPDFBtn(_ sender: Any) {
        // Create and add a PDFView to the view hierarchy.
       
    }
    
                                                                        
}
