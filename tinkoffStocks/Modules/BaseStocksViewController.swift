//
//  BaseStocksViewController.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//



import UIKit

protocol StocksControllerCoordinatorDelegate: class {
    func controllerDidFinish(_ controller: BaseStocksViewController)
}

class BaseStocksViewController: UIViewController {

    // MARK: - Variables public
    
    weak var coordinatorDelegate: StocksControllerCoordinatorDelegate?
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // colors
        
        view.backgroundColor = .black

        // keyboard
        
        setupKeyboardEvents()
    }
    
    // MARK: - Public methods
    
    func updateUIForKeyboardPresented(_ presented: Bool, frame: CGRect) {
        print("Need to override this method")
    }
    
    // MARK: - Private methods
    
    
    //
    // MARK: Keyboard Management

    private func setupKeyboardEvents() {

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustKeyboardOffset(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustKeyboardOffset(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }
    
    @objc private func adjustKeyboardOffset(notification: Notification) {

        guard
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
            let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else { return }

        let presented = notification.name != UIResponder.keyboardWillHideNotification
        updateUIForKeyboardPresented(presented, frame: frame)

        UIView.animate(
            withDuration: duration, delay: 0,
            options: [UIView.AnimationOptions(rawValue: curve.uintValue << 16), .beginFromCurrentState],
            animations: { self.view.layoutIfNeeded() },
            completion: nil
        )
    }
}
