//
//  NewsViewController.swift
//  Yandex Stocks
//
//  Created by Никита Казанцев on 28.03.2021.
//
// контроллер с таблицей где выводятся новости как-то связанные с рынком акций (влияющих на них косвенно или прямо)
import UIKit
import SnapKit
import Then
import SafariServices

class NewsViewController: BaseStocksViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {

    // MARK: - UI
    var activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    private var myArray: [NewsElement] = []
    

    private var filteredData: [NewsElement]!
    private var myTableView: UITableView!
    
    var searchBar: UISearchBar! = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        filteredData = myArray

        setupSearchBar()
        
        setupTableView()
        
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        
        loadMore()
        
        let tapOnScreen = UITapGestureRecognizer(target: self, action: #selector(closeEvent))
        tapOnScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnScreen)
        
    }
    
    func setupTableView() {
        
        let barHeight: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(NewsCell.self, forCellReuseIdentifier: "subtitleCell")
       
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        myTableView.backgroundColor = .black
        
        self.view.addSubview(myTableView) {
            $0.right.bottom.left.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom)
          }
    }
    
    func setupNavigationBar() {
        self.title = "News"
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.hidesBarsOnSwipe = true
        let loadMoreItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(loadMore))
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
    

    /**
     загружает новости с бэка
     */
    func loadNews() {
        APIManager.sharedInstance.getRequest(modelType: [NewsElement].self, url: "https://finnhub.io/api/v1/news?category=general") { result in
            switch result {
            case .success(let data):
                do {
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
                    self.myArray = data.sorted {
                        String($0.headline ?? "ZZ") < String($1.headline ?? "ZZ")
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
        loadNews()
      }
    
    @objc private func closeEvent() {
        view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.filteredData[indexPath.row].url != nil) {
        let svc = SFSafariViewController(url: URL(string: self.filteredData[indexPath.row].url!)!)
        present(svc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath) as! NewsCell
        cell.selectionStyle = .none
        
        cell.NameLabel.text = self.filteredData[indexPath.row].headline
        cell.smallLabel.text = self.filteredData[indexPath.row].category
        cell.loadImage(url: self.filteredData[indexPath.row].image!)
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredData = self.myArray.filter({ $0.headline?.lowercased().hasPrefix(searchText.lowercased()) ?? false })
        //change the condition as per your requirement......
        self.myTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.filteredData = self.myArray
        self.myTableView.reloadData()
    }
    
    
}
