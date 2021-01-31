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

class ViewController: BaseStocksViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {

    // MARK: - UI
    
    // индикатор загрузки по сети
    var activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    // сюда после нажатия кнопки Load More попадают акции, отдающиеся бэком
    private var myArray: [CompanyShortElement] = [CompanyShortElement(currency: "US", someDescription: "Apple inc", displaySymbol: "AAPL", figi: "BBG000BGHYF2", mic: "OTCM", symbol: "AAPL", type: "Common Stock"),
                                                  CompanyShortElement(currency: "US", someDescription: "Microsoft Corporation", displaySymbol: "MSFT", figi: "BBG1654BGHYS2", mic: "OTCM", symbol: "MSFT", type: "Common Stock"),
                                                  CompanyShortElement(currency: "US", someDescription: "Tesla Inc", displaySymbol: "TSLA", figi: "BBG001BGHYF2", mic: "OTCM", symbol: "TSLA", type: "Common Stock"),
                                                  CompanyShortElement(currency: "US", someDescription: "Macy's Inc", displaySymbol: "M", figi: "BBG001BGHYF6", mic: "OTCM", symbol: "M", type: "Common Stock"),
                                                  CompanyShortElement(currency: "US", someDescription: "Zoom Video Communications Inc", displaySymbol: "ZM", figi: "BBG001BGHYF3", mic: "OTCM", symbol: "ZM", type: "Common Stock"),
                                                  CompanyShortElement(currency: "US", someDescription: "Activision Blizzard, Inc.", displaySymbol: "ATVI", figi: "BBG001BGHYF3", mic: "OTCM", symbol: "ATVI", type: "Common Stock"),
                                                  ]
    
    // только отфильтрованные акции (при использовании searchBar)
    private var filteredData: [CompanyShortElement]!
    
    // список, выводящий все акции, загруженные на устройстве
    private var myTableView: UITableView!
    
    // строка поиска для быстрого поиска по акциям.
    // Поиск осуществляется по названию компании
    var searchBar: UISearchBar! = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .dark
            }
        
        setupNavigationBar()

        filteredData = myArray
        
        setupSearchBar()
        
        setupTableView()
        
        setupLoaderView()
        
        let tapOnScreen = UITapGestureRecognizer(target: self, action: #selector(closeEvent))
        tapOnScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnScreen)
    }
    
    func setupTableView() {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "subtitleCell")
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        myTableView.backgroundColor = .black
        
        self.view.addSubview(myTableView) {
            $0.right.bottom.left.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom)
          }
    }
    
    func setupLoaderView() {
        activityView.center = self.view.center
        self.view.addSubview(activityView)
    }
    
    func setupNavigationBar() {
        self.title = "Stocks"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.hidesBarsOnSwipe = true
        let loadMoreItem = UIBarButtonItem(title: "Load more", style: .plain, target: self, action: #selector(loadMore))
        navigationItem.rightBarButtonItems = [loadMoreItem]
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .black

        addSubview(searchBar) {
            $0.right.left.equalToSuperview()
            $0.top.equalTo(view.safeArea.top).offset(16)
        }
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
                        self.showError(error.localizedDescription)
                        self.activityView.stopAnimating()
                    }
                }
            }
        }
    }
    
    @objc func loadMore() {
        activityView.startAnimating()
        loadCompanies()
      }
    
    @objc private func closeEvent() {
        view.endEditing(true)
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath as IndexPath)
        
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitleCell")
        cell.selectionStyle = .none
        cell.backgroundColor = .black
        cell.textLabel!.text = "\(self.filteredData[indexPath.row].displaySymbol!)"
        
        if (self.filteredData[indexPath.row].someDescription != nil ) {
        cell.detailTextLabel!.text = "\(self.filteredData[indexPath.row].someDescription!)"
            cell.detailTextLabel!.textColor = .lightGray
        }
        cell.textLabel!.textColor = .white
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // фильтрация по совпадениям
        self.filteredData = self.myArray.filter({ $0.someDescription?.lowercased().hasPrefix(searchText.lowercased()) ?? false })
        self.myTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.filteredData = self.myArray
        self.myTableView.reloadData()
    }
    
    
}
