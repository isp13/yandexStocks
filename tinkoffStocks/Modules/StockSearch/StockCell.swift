//
//  StockCell.swift
//  Yandex Stocks
//
//  Created by Никита Казанцев on 28.03.2021.
//
// Ячейка, использующаяся в таблице главного контроллера ViewController
// вывод названия акции, названия компании

import UIKit
import SnapKit
import Realm

class StockCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    lazy var NameLabel: UILabel = {
       let lbl = UILabel(frame: CGRect())
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    lazy var descLabel: UILabel = {
       let lbl = UILabel(frame: CGRect())
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.textColor = .lightGray
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return lbl
    }()
    
    lazy var priceLabel: UILabel = {
       let lbl = UILabel(frame: CGRect())
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    lazy var changeLabel: UILabel = {
       let lbl = UILabel(frame: CGRect())
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.textColor = .systemGreen
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return lbl
    }()
    
    lazy var starButton: UIButton = {
       let btn = UIButton(frame: CGRect())
        btn.setImage(UIImage(systemName: "star"), for: .normal)
        btn.tintColor = .systemYellow
        return btn
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
        self.addSubview(NameLabel){label in
            label.top.equalToSuperview().offset(12)
            label.left.equalToSuperview().offset(16)
            label.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
            }
        
        self.addSubview(starButton){im in
            im.left.equalTo(NameLabel.snp.right)
            im.top.equalTo(NameLabel.snp.top)
            im.height.width.equalTo(NameLabel.snp.height)
            }
        
        self.addSubview(descLabel){label in
            label.left.equalTo(NameLabel.snp.left)
            label.top.equalTo(NameLabel.snp.bottom)
            label.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
            }
        
        self.addSubview(priceLabel){label in
            label.centerY.equalTo(NameLabel)
            label.right.equalToSuperview().inset(16)
            label.width.lessThanOrEqualToSuperview().multipliedBy(0.4)
            }
        
        self.addSubview(changeLabel){label in
            label.centerY.equalTo(descLabel)
            label.right.equalToSuperview().inset(16)
            label.width.lessThanOrEqualToSuperview().multipliedBy(0.4)
            }
    }
    
    func configure(model: CompanyShortElement) {
        // заполняем содержимое (лейблы) клетки
        NameLabel.text = model.displaySymbol ?? "None"
        descLabel.text = model.someDescription ?? ""
        priceLabel.text = ""
        changeLabel.text = ""
        
        if let displaySymbol = model.displaySymbol {
            loadPrice(displaySymbol: displaySymbol)
        }
        
    }
    
    // MARK: -Private API
    /**
     загружает все акции с бэка
     */
    private func loadPrice(displaySymbol: String) {
        APIManager.sharedInstance.getRequest(modelType: Quote.self, url: "https://finnhub.io/api/v1/quote?symbol=\(displaySymbol)") { result in
            switch result {
            case .success(let data):
                do {
                    guard let current = data.c, let open = data.o else { return }
                    DispatchQueue.main.async {
                        self.priceLabel.text = String(format: "%.3f", current)
                        
                        let difference = current - open
                        self.changeLabel.text = String(format: "%.3f", difference)
                        
                        if difference < 0 {
                            self.changeLabel.textColor = .systemRed
                        }
                        else {
                            self.changeLabel.textColor = .systemGreen
                        }
                    }
                }
            case .failure(let error):
                do {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        NameLabel.text = ""
        descLabel.text = ""
        priceLabel.text = ""
        changeLabel.text = ""
    }
}
