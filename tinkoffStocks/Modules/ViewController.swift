//
//  ViewController.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//

import UIKit
import SnapKit
import Then
import SafariServices
class ViewController: UIViewController {
    
    // MARK: - UI
    private var topLogo: UIImageView!
    private var topLabel: UILabel!
   

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        APIManager.sharedInstance.getRequest(modelType: BasicFinantials.self, url: "https://finnhub.io/api/v1/stock/metric?symbol=AAPL&metric=all&token=\(APIManager.sharedInstance.apiKey)") { result in
            print(result)
        }
        
        print("Login")
        super.viewDidLoad()
        
        setupUI()
        
        //navigationController?.setNavigationBarHidden(true, animated: false)
        
        print("LOADING")
    }
    
    
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        // title
        
        
        // subviews
        
        topLogo = UIImageView().then { uiimageview in
            
            uiimageview.image = UIImage()
            
            uiimageview.backgroundColor = .red
            
            addSubview(uiimageview) {
                $0.width.height.equalTo(100)
                $0.topMargin.equalToSuperview().offset(80)
                $0.centerX.equalToSuperview()
            }
        }
        
        topLabel = UILabel().then { topLabel in
            
            topLabel.numberOfLines = 0
            topLabel.font = UIFont.systemFont(ofSize: 27, weight: .bold)
            topLabel.textColor = UIColor.black
            
            let topLabelText = "Добро пожаловать!"
            
            let attributedString = NSMutableAttributedString(string: topLabelText)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                          value: paragraphStyle,
                                          range: NSMakeRange(0, attributedString.length))
            topLabel.attributedText = attributedString
            
            addSubview(topLabel) {
                $0.topMargin.equalTo(topLogo.snp.bottom).offset(16)
                $0.centerX.equalToSuperview()
            }
        }
        
     
 

        
        topLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLisense)))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeEvent)))
    }
    

    
    
    
   
    
  
    
    // MARK: - Events
    
    @objc private func closeEvent() {
        view.endEditing(true)
    }
    
    @objc private func openLisense() {
        let svc = SFSafariViewController(url: URL(string: "https://stackoverflow.com/questions/25945324/swift-open-link-in-safari")!)
        present(svc, animated: true, completion: nil)
    }
}


