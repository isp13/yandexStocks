//
//  ViewController.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//

import UIKit
import SwiftUI
import SnapKit
import Then

class DetailedViewController: BaseStocksViewController {
    
    // MARK: - UI
    var activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var companySymbol: String!
    var companyName: String!
    
    private var topLogo: UIImageView!
    private var topCompanySymbolLabel: UILabel!
    private var topCompanyFullNameLabel: UILabel!
    private var topCompanyCurrentPriceLabel: UILabel!
    
    // Low high 52 week section
    private var lowHighSection: UIView!
    
    private var lowSection: UIView!
    private var priceLowLabel: UILabel!
    private var priceLowDescLabel: UILabel!
    
    private var highSection: UIView!
    private var priceHighLabel: UILabel!
    private var priceHighDescLabel: UILabel!
    
    //add to favourite button
    private var favouriteButton: RoundedButton!
    //more data about company
    private var dataStackView: UIStackView = UIStackView()
    
    private var dataStackViewData: CompanyProfile?
    
    
    private var descLabel1: UILabel!
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 16
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    
    init( companySymbol: String, companyName: String) {
            self.companySymbol = companySymbol
            self.companyName = companyName
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
        
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
        
        
        favouriteButton = RoundedButton(type: .system).then { nextButton in
            
            nextButton.setTitle("Add to favourite", for: .normal)
            nextButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
            nextButton.onTap { [unowned self] _ in
                DispatchQueue.main.async {
                    
                }
                
            }
            
            addSubview(nextButton) {
                $0.height.equalTo(55)
                $0.centerX.equalToSuperview()
                $0.bottomMargin.equalToSuperview().inset(16)
                $0.width.equalToSuperview().multipliedBy(0.85)
            }
        }
        
        
        
    }
    
    func addUpperView() {
        topLogo = UIImageView().then { uiimageview in
            
            uiimageview.image = UIImage()
            
            uiimageview.backgroundColor = .white
            
            uiimageview.layer.masksToBounds = false
            uiimageview.layer.cornerRadius = 16
            uiimageview.clipsToBounds = true
            
            addSubview(uiimageview) {
                $0.topMargin.equalToSuperview().offset(16)
                $0.left.equalToSuperview().offset(16)
                $0.width.height.equalTo(32)
            }
        }
        
        topCompanySymbolLabel = UILabel().then { topLabel in
            topLabel.text = companySymbol
            topLabel.numberOfLines = 0
            topLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            topLabel.textColor = UIColor.white
            
            addSubview(topLabel) {
                $0.topMargin.equalTo(topLogo.snp.topMargin)
                $0.left.equalTo(topLogo.snp.right).offset(4)
            }
        }
        
        topCompanyFullNameLabel = UILabel().then { topLabel in
            topLabel.text = companyName
            topLabel.numberOfLines = 2
            topLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            topLabel.textColor = .lightGray
            
            addSubview(topLabel) {
                $0.centerY.equalTo(topCompanySymbolLabel.snp.centerY)
                $0.left.equalTo(topCompanySymbolLabel.snp.right).offset(16)
                $0.right.equalToSuperview().inset(16)
            }
        }
        
        topCompanyCurrentPriceLabel = UILabel().then { topLabel in
            topLabel.text = "-"
            topLabel.numberOfLines = 0
            topLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            topLabel.textColor = .lightGray
            
            addSubview(topLabel) {
                $0.top.equalTo(topCompanySymbolLabel.snp.bottom).offset(4)
                $0.left.equalToSuperview().offset(16)
            }
        }
    }
    
    func addLowHigh52SectionView() {
        lowHighSection = UIView()
        lowSection = UIView()
        highSection = UIView()
        
        priceLowLabel = UILabel().then { dsLabel in
            dsLabel.text = "-"
            dsLabel.numberOfLines = 0
            dsLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            dsLabel.textColor = .white
            
            lowSection.addSubview(dsLabel) {
                //$0.top.equalToSuperview().offset(12)
                $0.left.equalToSuperview()
            }
        }
        
        priceLowDescLabel = UILabel().then { dsLabel in
            dsLabel.text = "52 weeks min"
            dsLabel.numberOfLines = 0
            dsLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            dsLabel.textColor = .lightGray
            
            lowSection.addSubview(dsLabel) {
                $0.top.equalTo(priceLowLabel.snp.bottom).offset(4)
                $0.left.equalTo(priceLowLabel.snp.left)
            }
        }
        
        
        
        priceHighLabel = UILabel().then { dsLabel in
            dsLabel.text = "-"
            dsLabel.numberOfLines = 0
            dsLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            dsLabel.textColor = .white
            
            highSection.addSubview(dsLabel) {
                $0.left.equalToSuperview()
            }
        }
        
        priceHighDescLabel = UILabel().then { dsLabel in
            dsLabel.text = "52 weeks max"
            dsLabel.numberOfLines = 0
            dsLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            dsLabel.textColor = .lightGray
            
            highSection.addSubview(dsLabel) {
                $0.top.equalTo(priceHighLabel.snp.bottom).offset(4)
                $0.left.equalTo(priceHighLabel.snp.left)
            }
        }
        
        lowHighSection.addSubview(lowSection) {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(100)
            
        }
        
        lowHighSection.addSubview(highSection) {
            $0.top.equalToSuperview()
            $0.left.equalTo(lowSection.snp.right)
        }
        
        scrollViewContainer.addArrangedSubview(lowHighSection) {
            $0.top.equalToSuperview().offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(50)
        }
    }
    
    func addDataStackView(_ data: CompanyProfile) {
        DispatchQueue.main.async {
            self.dataStackView.spacing = 30
            self.dataStackView.axis = .vertical
            for (key,value) in data.allProperties() {
                print(key,value)
                let newView = UIView()
                let newLabel = UILabel() // main label
                let newLabel2 = UILabel() // desc label
                
                newLabel.text = key
                newLabel.textColor = .white
                newLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                
                if let b = value as? [String: String]{
                    newLabel2.text = b["some"]
                } else {
                    if let bb = value as? [String: Double] {
                        newLabel2.text = String(bb["some"]!)
                    } else {
                        newLabel2.text = "-"
                    }
                }
                
                print(value)
                
                newLabel2.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                newLabel2.textColor = .white
                
                newView.addSubview(newLabel) {
                    $0.left.equalToSuperview()
                    $0.top.equalToSuperview()
                    $0.width.lessThanOrEqualToSuperview().multipliedBy(0.45)
                }
                
                newView.addSubview(newLabel2) {
                    $0.right.equalToSuperview()
                    $0.top.equalToSuperview()
                    $0.width.lessThanOrEqualToSuperview().multipliedBy(0.45)
                }
                
                let divider = UIView()
                divider.backgroundColor = .lightGray
                divider.layer.opacity = 0.1
                
                newView.addSubview(divider) {
                    $0.left.equalTo(newLabel.snp.right).offset(2)
                    $0.right.equalTo(newLabel2.snp.left).offset(2)
                    $0.height.equalTo(1)
                    $0.bottom.equalTo(newLabel.snp.bottom)
                }
                
                self.dataStackView.addArrangedSubview(newView)
            }
            
            
            self.scrollViewContainer.addArrangedSubview(self.dataStackView) {
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().inset(16)
            }
            
            
            let tmpView = UIView()
            self.scrollViewContainer.addArrangedSubview(tmpView) {
                $0.left.equalToSuperview().offset(16)
                $0.height.equalTo(250)
            }
        }
    }
    
    func addScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topCompanyCurrentPriceLabel.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // this is important for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    func fillDetailedInformation() {
        if (self.dataStackViewData != nil ) {
            self.addDataStackView(self.dataStackViewData!)
        }
    }
    
    
    
    /// make a request to server to get metric
    /// - Parameter company: which company metrics need to request
    private func requestCompany(for company: String) {
        APIManager.sharedInstance.getRequest(modelType: BasicFinantials.self, url: "https://finnhub.io/api/v1/stock/metric?symbol=\(company)&metric=all&token=\(APIManager.sharedInstance.apiKey)") { result in
            switch result {
            case .success(let data): self.updateMainData(data)
            case .failure(let error): print(error)
            }
        }
        
        APIManager.sharedInstance.getRequest(modelType: StockPrice.self, url: "https://finnhub.io/api/v1/stock/candle?symbol=\(company)&resolution=D&from=\(Int(Calendar.current.date(byAdding: .day, value: -365, to: Date())!.timeIntervalSince1970))&to=\(Int(Date().timeIntervalSince1970))&token=\(APIManager.sharedInstance.apiKey)") { result in
            switch result {
            case .success(let data): self.loadChart(data)
            case .failure(let error): print(error)
            }
        }
        
        // /stock/profile?symbol=AAPL
        
        APIManager.sharedInstance.getRequest(modelType: CompanyProfile.self, url: "https://finnhub.io/api/v1/stock/profile2?symbol=\(companySymbol ?? "AAPL")&token=\(APIManager.sharedInstance.apiKey)") { result in
            switch result {
            case .success(let data):
                do {
                    print("\n\n\n\n\n\n")
                    print(data)
                    print("\n\n\n\n\n\n")
                    self.updateImage(data)
                    self.dataStackViewData = data
                }
            case .failure(let error):
                do {
                    print("\n\n\n\n\n\n")
                    print(error)
                    print("\n\n\n\n\n\n")
                }
            }
        }
    }
    
    private func updateImage(_ data: CompanyProfile) {
        if (data.logo != nil) {
        DispatchQueue.main.async {
            self.topLogo.loadImageUsingCacheWithURLString(data.logo!, placeHolder: UIImage())
        }
        }
    }
    
    private func loadChart(_ data: StockPrice) {
        DispatchQueue.main.async {
            if (data.c != nil ) {
                let swiftUIView = LineView(data: data.c!, title: "")
                self.topCompanyCurrentPriceLabel.text = String(data.c!.last!)
                
                let childView = UIHostingController(rootView: swiftUIView)
                self.addChild(childView)
                //childView.view.frame = scrollViewContainer.bounds
                
                self.scrollViewContainer.addArrangedSubview(childView.view)
                {
                    $0.top.equalTo(self.lowHighSection.snp.bottom).offset(40)
                    $0.left.equalToSuperview().offset(16)
                    $0.right.equalToSuperview().inset(16)
                    $0.height.equalTo(200)
                }
                childView.didMove(toParent: self)
                
                self.activityView.stopAnimating()
                
                self.fillDetailedInformation()
            }
        }
    }
    
    private func updateMainData(_ data: BasicFinantials) {
        DispatchQueue.main.async {
            //self.topCompanySymbolLabel.text = (String(data.metric?.s ?? 0))
            self.priceLowLabel.text = String(data.metric?.the52WeekLow ?? 0)
            self.priceHighLabel.text = String(data.metric?.the52WeekHigh ?? 0)
        }
    }
}


