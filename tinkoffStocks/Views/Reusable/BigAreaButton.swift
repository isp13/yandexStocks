//
//  BigAreaButton.swift
//  Yandex Stocks
//
//  Created by Никита Казанцев on 28.03.2021.
//

import UIKit

class BiggerAreaButton: UIButton {
    
    @IBInspectable var clickableInset: CGFloat = 0

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let insetFrame = bounds.insetBy(dx: clickableInset, dy: clickableInset)
        return insetFrame.contains(point)
    }
}
