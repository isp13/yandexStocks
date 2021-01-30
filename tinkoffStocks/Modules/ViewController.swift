//
//  ViewController.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//

import UIKit
import SnapKit
import Then
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {

    // MARK: - UI
    var activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    private var myArray: [CompanyShortElement] = [CompanyShortElement(currency: "US", someDescription: "Apple inc", displaySymbol: "AAPL", figi: "BBG000BGHYF2", mic: "OTCM", symbol: "AAPL", type: "Common Stock")]
    
    private var filteredData: [CompanyShortElement]!
    private var myTableView: UITableView!
    
    var searchBar: UISearchBar! = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredData = myArray

        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        searchBar.delegate = self
        
        addSubview(searchBar) {
            $0.right.left.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(self.view.frame.height - 150)
        }
        
        
        self.view.addSubview(myTableView) {
            $0.right.bottom.left.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom)
          }
        
        myTableView.backgroundColor = .black
        
        self.view.backgroundColor = .black
        
        activityView.center = self.view.center
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = UIColor(named: "mainBackgroundView")
        
        self.view.addSubview(activityView)
        activityView.startAnimating()
        
       self.loadCompanies()
    }
    
    
    func loadCompanies() {
        APIManager.sharedInstance.getRequest(modelType: CompanyShort.self, url: "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=\(APIManager.sharedInstance.apiKey)") { result in
            switch result {
            case .success(let data):
                do {
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
                    self.myArray = data.sorted {
                        String($0.displaySymbol ?? "ZZ") < String($1.displaySymbol ?? "ZZ")
                      }
                        
                        self.filteredData = self.myArray
                        self.myTableView.reloadData()
                    }
                }
            case .failure(let error):
                do {
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        if (myArray[indexPath.row].symbol != nil) {
            //myArray[indexPath.row].symbol!
        self.present(DetailedViewController(companySymbol: filteredData[indexPath.row].symbol!, companyName: filteredData[indexPath.row].someDescription ?? ""), animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.backgroundColor = .black
        cell.textLabel!.text = "\(self.filteredData[indexPath.row].displaySymbol!)"
        cell.textLabel!.textColor = .white
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredData = self.myArray.filter({ $0.someDescription?.lowercased().hasPrefix(searchText.lowercased()) ?? false })
        //change the condition as per your requirement......
        self.myTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.filteredData = self.myArray
        self.myTableView.reloadData()
    }
}
