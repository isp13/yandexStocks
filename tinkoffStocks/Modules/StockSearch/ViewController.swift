//
//  ViewController.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//
// Контроллер с таблицей всех акций. есть возможность сортировать, выводить только избранные, переходить в детальный контроллер с инфой об конкретной акции

import UIKit
import SnapKit
import Then
import UIKit
import RealmSwift

class ViewController: BaseStocksViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {

    // Get the default Realm
    let realm = try! Realm()
    
    // в текущий момент показывается вкладка избранное или все акции
    var isShowingFavourite = false
    // MARK: - UI
    
    // индикатор загрузки по сети
    var activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    // сюда после нажатия кнопки Load More попадают акции, отдающиеся бэком
    private var myArray: [CompanyShortElement] = [CompanyShortElement(currency: "US", description: "Apple inc", displaySymbol: "AAPL", figi: "BBG000BGHYF2", mic: "OTCM", symbol: "AAPL", type: "Common Stock"),
                                                  CompanyShortElement(currency: "US", description: "Microsoft Corporation", displaySymbol: "MSFT", figi: "BBG1654BGHYS2", mic: "OTCM", symbol: "MSFT", type: "Common Stock"),
                                                  CompanyShortElement(currency: "US", description: "Tesla Inc", displaySymbol: "TSLA", figi: "BBG001BGHYF2", mic: "OTCM", symbol: "TSLA", type: "Common Stock"),
                                                  CompanyShortElement(currency: "US", description: "Macy's Inc", displaySymbol: "M", figi: "BBG001BGHYF6", mic: "OTCM", symbol: "M", type: "Common Stock"),
                                                  CompanyShortElement(currency: "US", description: "Zoom Video Communications Inc", displaySymbol: "ZM", figi: "BBG001BGHYF3", mic: "OTCM", symbol: "ZM", type: "Common Stock"),
                                                  CompanyShortElement(currency: "US", description: "Activision Blizzard, Inc.", displaySymbol: "ATVI", figi: "BBG001BGHYF3", mic: "OTCM", symbol: "ATVI", type: "Common Stock"),
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
        
        setupNavigationBar()

        filteredData = myArray
        
        setupSearchBar()
        
        setupTableView()
        
        setupLoaderView()
        
        // по тапу в любую часть экрана закроется клавиатура
        let tapOnScreen = UITapGestureRecognizer(target: self, action: #selector(closeEvent))
        tapOnScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnScreen)
    }
    
    func setupTableView() {
        let barHeight: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(StockCell.self, forCellReuseIdentifier: "stockCell")
        
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
        let loadMoreItem = UIBarButtonItem(title: "Load all", style: .plain, target: self, action: #selector(loadMore))
        let favItem = UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(loadFavourite))
        navigationItem.rightBarButtonItems = [loadMoreItem]
        navigationItem.leftBarButtonItems = [favItem]
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
    
    /**
     загружает все акции с бэка
     */
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
    
    
    /**
     Если надо вывести избранные - Из бд реалма вытаскиваем только избранные, обновляем таблицу
        Иначе выводим все акции
     */
    @objc func loadFavourite() {
        isShowingFavourite.toggle()
        
        DispatchQueue.main.async {
            if (self.isShowingFavourite) {
                self.navigationItem.leftBarButtonItem?.title = "show All"
                self.filteredData = Array(self.realm.objects(CompanyShortElement.self))
                self.myTableView.reloadData()
        }
        else {
            self.navigationItem.leftBarButtonItem?.title = "Favourite"
            self.filteredData = self.myArray
            self.myTableView.reloadData()
        }
        }
      }
    
    // срабатывает по нажатию кнопки в верхнем баре
    @objc func loadMore() {
        isShowingFavourite = false
        self.navigationItem.leftBarButtonItem?.title = "Favourite"
        activityView.startAnimating()
        loadCompanies()
      }
    
    // чтоб закрывать клавиатуру
    @objc private func closeEvent() {
        view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        if (myArray[indexPath.row].symbol != nil) {
            //myArray[indexPath.row].symbol!
            let vc = DetailedViewController(companySymbol: filteredData[indexPath.row].symbol!, companyName: filteredData[indexPath.row].someDescription ?? "")
            
            self.present(vc, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockCell
        cell.selectionStyle = .none

        // заполняем содержимое (лейблы) клетки
        cell.NameLabel.text = "\(self.filteredData[indexPath.row].displaySymbol ?? "None")"
        cell.descLabel.text = "\(self.filteredData[indexPath.row].someDescription ?? "")"
        
        
        // смотрим, данная клетка является ли избранной акцией
        // если да - закрашиваем звездочку
        let query = NSPredicate(format:"displaySymbol == %@", self.filteredData[indexPath.row].displaySymbol!)
        if ((realm.objects(CompanyShortElement.self).filter(query)).count == 1)
        {
            
            cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        else {
            cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        // добавляем привязку к функции в слуяае нажатия на звездочку
        cell.starButton.addTarget(self, action: #selector(onStarButton(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func onStarButton(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is StockCell) {
            superview = view.superview
        }
        guard let cell = superview as? StockCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = myTableView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        
        // если эта акция не в избранном, а пользовательь нажал на звездочку, значит нужно добавить в избранное
        // сохраняем в реалм
        DispatchQueue.main.async {
        let query = NSPredicate(format:"displaySymbol == %@", self.filteredData[indexPath.row].displaySymbol!)
            if ((self.realm.objects(CompanyShortElement.self).filter(query)).count == 0) {
            try! self.realm.write {
                self.realm.add(self.filteredData[indexPath.row])
                cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
            print("button is in row \(indexPath.row)")
        }
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // фильтрация по совпадениям
        self.filteredData = self.myArray.filter({ $0.someDescription?.lowercased().hasPrefix(searchText.lowercased()) ?? false })
        self.myTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // если нажат крестик - вывести обратно все акции
        searchBar.text = nil
        self.filteredData = self.myArray
        self.myTableView.reloadData()
    }
    
    
}
