//
//  RoundedButton.swift
//  Yandex Stocks
//
//  Created by Никита Казанцев on 28.03.2021.
//



import UIKit

class RoundedButton: TappableButton {
    
    // MARK: - Variables private
    
    private var oldFrame: CGRect = .zero
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if oldFrame != frame {
            layer.cornerRadius = frame.height / 2
            oldFrame = frame
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {

        // font
        setTitleColor(.black, for: .normal)
        backgroundColor = .lightGray
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        // layer
        layer.masksToBounds = true
    }
}
