//
//  PXGraphicsItem.swift
//  PXPen
//
//  Created by gzj on 2025/1/8.
//

import UIKit

class PXGraphicsItem {
    let identifier: String
    init() {
        self.identifier = UUID().uuidString
    }
}

class PXGraphicsPolygonItem: PXGraphicsItem {
    
}

class PXGraphicsStrokesGroup: PXGraphicsItem {
    
}



