//
//  ViewController.swift
//  PXPen
//
//  Created by gzj on 2025/1/8.
//

import UIKit

class ViewController: UIViewController {

    var drawView: PXPenDrawingView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        let drawView = PXPenDrawingView(frame: self.view.bounds)
        drawView.backgroundColor = UIColor.lightText
        self.view.addSubview(drawView)
        self.drawView = drawView
        
    }


}

