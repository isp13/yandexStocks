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
    var companySymbol: String = "AAPL"
    var companyName: String = "Apple inc"
    
    private var topLogo: UIImageView!
    private var topCompanySymbolLabel: UILabel!
    private var topCompanyFullNameLabel: UILabel!
    
    // Low high 52 week section
    private var lowHighSection: UIView!
    
    private var lowSection: UIView!
    private var priceLowLabel: UILabel!
    private var priceLowDescLabel: UILabel!
    
    private var highSection: UIView!
    private var priceHighLabel: UILabel!
    private var priceHighDescLabel: UILabel!
    
    
    private var descLabel1: UILabel!
    
    let scrollViewContainer: UIStackView = {
         let view = UIStackView()

         view.axis = .vertical
         view.spacing = 10

         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
   

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        
        
        print("Login")
        super.viewDidLoad()
        
        setupUI()
        
        //navigationController?.setNavigationBarHidden(true, animated: false)
        requestCompany(for: companySymbol)
        print("LOADING")
    }
    
    
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        // title
        
        
        // subviews
        
        addUpperView()
        
        addScrollView()
        
        addLowHigh52SectionView()
        
        let tmpView = UIView()
        
        
        scrollViewContainer.addArrangedSubview(tmpView) {
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(1000)
        }
     
 

        
        topCompanySymbolLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLisense)))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeEvent)))
    }
    
    func addUpperView() {
        topLogo = UIImageView().then { uiimageview in
            
            uiimageview.image = UIImage()
            
            uiimageview.backgroundColor = .red
            
            addSubview(uiimageview) {
                $0.width.height.equalTo(100)
                $0.topMargin.equalToSuperview().offset(80)
                $0.centerX.equalToSuperview()
            }
        }
        
        topCompanySymbolLabel = UILabel().then { topLabel in
            
            topLabel.numberOfLines = 0
            topLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            topLabel.textColor = UIColor.black
            
            let topLabelText = companySymbol
            
            let attributedString = NSMutableAttributedString(string: topLabelText)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                          value: paragraphStyle,
                                          range: NSMakeRange(0, attributedString.length))
            topLabel.attributedText = attributedString
            
            addSubview(topLabel) {
                $0.topMargin.equalTo(topLogo.snp.bottom).offset(16)
                $0.left.equalToSuperview().offset(16)
            }
        }
        
        topCompanyFullNameLabel = UILabel().then { topLabel in
            
            topLabel.numberOfLines = 0
            topLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            topLabel.textColor = .lightGray
            
            let topLabelText = companyName
            
            let attributedString = NSMutableAttributedString(string: topLabelText)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                          value: paragraphStyle,
                                          range: NSMakeRange(0, attributedString.length))
            topLabel.attributedText = attributedString
            
            addSubview(topLabel) {
                $0.centerY.equalTo(topCompanySymbolLabel.snp.centerY)
                $0.left.equalTo(topCompanySymbolLabel.snp.right).offset(16)
            }
        }
        }
    
    func addLowHigh52SectionView() {
        lowHighSection = UIView()
        lowSection = UIView()
        highSection = UIView()
        
        priceLowLabel = UILabel().then { dsLabel in
            
            dsLabel.numberOfLines = 0
            dsLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            dsLabel.textColor = .black
            
            let topLabelText = "-"
            
            let attributedString = NSMutableAttributedString(string: topLabelText)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                          value: paragraphStyle,
                                          range: NSMakeRange(0, attributedString.length))
            dsLabel.attributedText = attributedString
            
            lowSection.addSubview(dsLabel) {
                //$0.top.equalToSuperview().offset(12)
                $0.left.equalToSuperview()
            }
        }
        
        priceLowDescLabel = UILabel().then { dsLabel in
            
            dsLabel.numberOfLines = 0
            dsLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            dsLabel.textColor = .lightGray
            
            let topLabelText = "52 weeks min"
            
            let attributedString = NSMutableAttributedString(string: topLabelText)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                          value: paragraphStyle,
                                          range: NSMakeRange(0, attributedString.length))
            dsLabel.attributedText = attributedString
            
            lowSection.addSubview(dsLabel) {
                $0.top.equalTo(priceLowLabel.snp.bottom).offset(4)
                $0.left.equalTo(priceLowLabel.snp.left)
            }
        }
        
        
        
        priceHighLabel = UILabel().then { dsLabel in
            
            dsLabel.numberOfLines = 0
            dsLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            dsLabel.textColor = .black
            
            let topLabelText = "-"
            
            let attributedString = NSMutableAttributedString(string: topLabelText)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                          value: paragraphStyle,
                                          range: NSMakeRange(0, attributedString.length))
            dsLabel.attributedText = attributedString
            
            highSection.addSubview(dsLabel) {
                $0.left.equalToSuperview()
            }
        }
        
        priceHighDescLabel = UILabel().then { dsLabel in
            
            dsLabel.numberOfLines = 0
            dsLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            dsLabel.textColor = .lightGray
            
            let topLabelText = "52 weeks max"
            
            let attributedString = NSMutableAttributedString(string: topLabelText)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                          value: paragraphStyle,
                                          range: NSMakeRange(0, attributedString.length))
            dsLabel.attributedText = attributedString
            
            highSection.addSubview(dsLabel) {
                //$0.top.equalToSuperview().offset(12)
                $0.top.equalTo(priceHighLabel.snp.bottom).offset(4)
                $0.left.equalTo(priceHighLabel.snp.left)
            }
        }
        
        lowHighSection.addSubview(lowSection) {
            //$0.top.equalToSuperview().offset(12)
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(100)
        }
        
        lowHighSection.addSubview(highSection) {
            //$0.top.equalToSuperview().offset(12)
            $0.top.equalToSuperview()
            $0.left.equalTo(lowSection.snp.right)
        }
        
        scrollViewContainer.addArrangedSubview(lowHighSection) {
            $0.left.equalToSuperview().offset(16)
        }
    }
    
    func addScrollView() {
        view.addSubview(scrollView)
                scrollView.addSubview(scrollViewContainer)

                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                scrollView.topAnchor.constraint(equalTo: topCompanySymbolLabel.bottomAnchor).isActive = true
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

                scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
                scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
                scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
                scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
                // this is important for scrolling
                scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    

    
    /// make a request to server to get metric
    /// - Parameter company: which company metrics need to request
    private func requestCompany(for company: String) {
        APIManager.sharedInstance.getRequest(modelType: BasicFinantials.self, url: "https://finnhub.io/api/v1/stock/metric?symbol=\(company)&metric=all&token=\(APIManager.sharedInstance.apiKey)") { result in
            switch result {
                    case .success(let data): self.updateData(data)
                    case .failure(let error): print(error)
                }
        }
    }
    
    private func updateData(_ data: BasicFinantials) {
        print(data)
        print("\n\n\n\n")
        DispatchQueue.main.async {
            //self.topCompanySymbolLabel.text = (String(data.metric?.s ?? 0))
            self.priceLowLabel.text = String(data.metric?.the52WeekLow ?? 0)
            self.priceHighLabel.text = String(data.metric?.the52WeekHigh ?? 0)
        }
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


