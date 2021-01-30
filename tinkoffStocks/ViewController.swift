//
//  ViewController.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        APIManager.sharedInstance.getRequest(modelType: BasicFinantials.self, url: "https://finnhub.io/api/v1/stock/metric?symbol=AAPL&metric=all&token=\(APIManager.sharedInstance.apiKey)") { result in
            print(result)
        }
    }


}

