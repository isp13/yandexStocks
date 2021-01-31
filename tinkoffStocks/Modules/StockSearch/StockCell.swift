//
//  StockCell.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 31.01.2021.
//
// Ячейка, использующаяся в таблице главного контроллера ViewController
// вывод названия акции, названия компании

import UIKit
import SnapKit

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
    
    lazy var starButton: UIButton = {
       let btn = UIButton(frame: CGRect())
        btn.setImage(UIImage(systemName: "star"), for: .normal)
        
        return btn
    }()
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        

        self.addSubview(starButton){btn in
            btn.right.equalToSuperview().inset(4)
            btn.height.equalToSuperview()
            }
        
        // название статьи
        self.addSubview(NameLabel){label in
            label.left.equalToSuperview().offset(16)
            label.height.equalToSuperview()
            }
        
        self.addSubview(descLabel){label in
            label.left.equalTo(NameLabel.snp.right).offset(4)
            label.height.equalToSuperview()
            label.width.lessThanOrEqualToSuperview().multipliedBy(0.40)
            }
        
        
    }


}
