//
//  TappableButton.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//


import UIKit


typealias TypeClosure<T> = (T) -> Void

typealias EmptyClosure = () -> Void
typealias StringClosure = TypeClosure<String>
typealias BoolClosure = TypeClosure<Bool>
typealias ErrorClosure = TypeClosure<Error?>

class TappableButton: BiggerAreaButton {

    //
    // MARK: - Public Accessors

    func onTap(completion: @escaping TypeClosure<UIButton>) {
        addTarget(self, action: #selector(onTapEvent(_:)), for: .touchUpInside)
        tapClosure = completion
    }

    var isLoading: Bool = false {
        didSet {
            if isLoading {
                indicatorView.startAnimating()
                tempTitleStorage = title(for: .normal)
                setTitle(nil, for: .normal)
            } else if let tempTitleStorage = tempTitleStorage {
                indicatorView.stopAnimating()
                setTitle(tempTitleStorage, for: .normal)
            } else if image(for: .normal) != nil {
                indicatorView.stopAnimating()
            }
        }
    }

    func setIsLoading(_ value: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.isLoading = value
        }
    }

    //
    // MARK: - Private Stuff
    
    private var tapClosure: TypeClosure<UIButton>?
    private var tempTitleStorage: String?

    private lazy var indicatorView = UIActivityIndicatorView().then { v in

        v.color = titleColor(for: .normal)
        v.hidesWhenStopped = true
        
        addSubview(v) { $0.center.equalToSuperview() }
    }

    @objc private func onTapEvent(_ sender: UIButton) {
        tapClosure?(sender)
    }
}

