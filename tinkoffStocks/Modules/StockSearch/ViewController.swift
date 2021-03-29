//
//  ViewController.swift
//  Yandex Stocks
//
//  Created by Никита Казанцев on 28.03.2021.
//
// Контроллер с таблицей всех акций. есть возможность сортировать, выводить только избранные, переходить в детальный контроллер с инфой об конкретной акции

import UIKit
import SnapKit
import Then
import UIKit
import RealmSwift

class ViewController: BaseStocksViewController  {

    // Get the default Realm
    let realm = try! Realm()
    
    // в текущий момент показывается вкладка избранное или все акции
    var isShowingFavourite = false
    // MARK: - UI
    
    // индикатор загрузки по сети
    var activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    // сюда после нажатия кнопки Load More попадают акции, отдающиеся бэком
    private var myArray: [CompanyShortElement] = []
    
    // только отфильтрованные акции (при использовании searchBar)
    private var filteredData: [CompanyShortElement]!
    
    // список, выводящий все акции, загруженные на устройстве
    private var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()

        filteredData = myArray
 
        setupTableView()
        setupSearchBar()
        setupLoaderView()
        
        loadCompanies()
        
        // по тапу в любую часть экрана закроется клавиатура
        let tapOnScreen = UITapGestureRecognizer(target: self, action: #selector(closeEvent))
        tapOnScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnScreen)
    }
    
    // MARK: -Setup UI
    
    func setupLoaderView() {
        activityView.center = self.view.center
        self.view.addSubview(activityView)
    }
    
    func setupNavigationBar() {
        self.title = "Stocks"
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.hidesBarsOnSwipe = false
        let loadMoreItem = UIBarButtonItem(title: "Load all", style: .plain, target: self, action: #selector(loadMore))
        let favItem = UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(loadFavourite))
        navigationItem.rightBarButtonItems = [loadMoreItem]
        navigationItem.leftBarButtonItems = [favItem]
    }
    
    func setupSearchBar() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
       // navigationItem.searchController?.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
    }
    
    func setupTableView() {
        myTableView = UITableView(frame: .zero, style: .plain)
        myTableView.register(StockCell.self, forCellReuseIdentifier: "stockCell")
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        myTableView.backgroundColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchBarOnEmptyAreaTap))
        self.myTableView.backgroundView = UIView()
        self.myTableView.backgroundView?.addGestureRecognizer(tap)
        
        self.view.addSubview(myTableView) {
            $0.right.bottom.left.equalToSuperview()
            $0.top.equalToSuperview()
          }
    }
    
    
    // MARK: -Private API
    /**
     загружает все акции с бэка
     */
    private func loadCompanies() {
        APIManager.sharedInstance.getRequest(modelType: CompanyShort.self, url: "https://finnhub.io/api/v1/stock/symbol?exchange=US") { result in
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
    @objc private func loadFavourite() {
        isShowingFavourite.toggle()
        
        
        DispatchQueue.main.async {
            if (self.isShowingFavourite) {
                self.title = "Favourite"
                self.navigationItem.leftBarButtonItem?.title = "show All"
                self.filteredData = Array(self.realm.objects(CompanyShortElement.self))
                self.myTableView.reloadData()
        }
        else {
            self.title = "All stocks"
            self.navigationItem.leftBarButtonItem?.title = "Favourite"
            self.filteredData = self.myArray
            self.myTableView.reloadData()
        }
        }
      }
    
    /* срабатывает по нажатию кнопки в верхнем баре */
    @objc private func loadMore() {
        isShowingFavourite = false
        self.navigationItem.leftBarButtonItem?.title = "Favourite"
        activityView.startAnimating()
        loadCompanies()
      }
    
    /* чтоб закрывать клавиатуру */
    @objc private func closeEvent() {
        view.endEditing(true)
    }

    
    /* Лайк акции (добавление в избранные) */
    @objc private func onStarButtonTapped(_ sender: UIButton) {
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
    
    /* По тапу на пустую часть тейбл вью отменяем поиск */
    @objc private func searchBarOnEmptyAreaTap() {
        navigationItem.searchController?.isActive = false
        navigationItem.searchController?.searchBar.text = ""
        self.filteredData = self.myArray
        self.myTableView.reloadData()
    }

}


// MARK: -UISearchBarDelegate

extension ViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // фильтрация по совпадениям
        self.filteredData = self.myArray.filter({ $0.someDescription?.lowercased().hasPrefix(searchText.lowercased()) ?? false })
        self.myTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filteredData = self.myArray
        self.myTableView.reloadData()
    }
}


// MARK: -UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        if let symbol = filteredData[indexPath.row].symbol {
            let vc = DetailedViewController(companySymbol: symbol, companyName: filteredData[indexPath.row].someDescription ?? "")
            self.present(vc, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockCell
        cell.selectionStyle = .none

        cell.configure(model: filteredData[indexPath.row])
        
        // смотрим, данная клетка является ли избранной акцией
        // если да - закрашиваем звездочку
        let query = NSPredicate(format:"displaySymbol == %@", filteredData[indexPath.row].displaySymbol!)
        if ((realm.objects(CompanyShortElement.self).filter(query)).count == 1)
        {
            
            cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        else {
            cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        // добавляем привязку к функции в слуяае нажатия на звездочку
        cell.starButton.addTarget(self, action: #selector(onStarButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
}
