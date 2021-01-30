//
//  UIViewSnapKitExt.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//

import UIKit
import SnapKit

public extension UIView {
    
    var safeArea : ConstraintLayoutGuideDSL {
        return safeAreaLayoutGuide.snp
    }

    func addSubview(_ subview: UIView, makeConstraints: (ConstraintMaker) -> Void) {
        addSubview(subview)
        subview.snp.makeConstraints { makeConstraints($0) }
    }
       
}

public extension UIViewController {

    func addSubview(_ subview: UIView, makeConstraints: (ConstraintMaker) -> Void) {
        view.addSubview(subview)
        subview.snp.makeConstraints { makeConstraints($0) }
    }
}

public extension UIStackView {
    func addArrangedSubview(_ subview: UIView, makeConstraints: (ConstraintMaker) -> Void) {
        self.addArrangedSubview(subview)
        subview.snp.makeConstraints { makeConstraints($0) }
    }
}
