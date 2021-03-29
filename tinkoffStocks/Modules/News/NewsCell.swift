//
//  NewsCell.swift
//  Yandex Stocks
//
//  Created by Никита Казанцев on 28.03.2021.
//
// Ячейка, использующаяся в при выводе новостей
// вывод названия новости, картинки


import UIKit

class NewsCell: UITableViewCell {
    
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
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return lbl
    }()
    
    lazy var SmallIconimage: UIImageView = {
        let im = UIImageView(image: UIImage(systemName: "newspaper"))
        im.contentMode = .scaleAspectFit
        im.tintColor = .white
        return im
    }()
    
    lazy var smallLabel: UILabel = {
       let lbl = UILabel(frame: CGRect())
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.textColor = .lightGray
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return lbl
    }()
    
    lazy var Iconimage: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // верхняя иконка в левом углу, характеризующая тип новости
        self.addSubview(SmallIconimage){im in
            im.left.equalToSuperview().offset(16)
            im.top.equalToSuperview().offset(8)
            im.width.height.equalTo(24)
            }
        
        // вывод типа новости (бизнес, обычная)
        self.addSubview(smallLabel){label in
            label.left.equalTo(SmallIconimage.snp.right).offset(4)
            label.centerY.equalTo(SmallIconimage)
            }
        
        // название статьи
        self.addSubview(NameLabel){label in
            label.left.equalToSuperview().offset(16)
            label.right.equalToSuperview().inset(16)
            label.top.equalTo(SmallIconimage.snp.bottom).offset(8)
            }
        
        // картинка новости
        self.addSubview(Iconimage){ im in
            im.top.equalTo(NameLabel.snp.bottom).offset(8)
            im.width.equalToSuperview()
            im.height.equalTo(250)
        }
    }
    
    /**
     загружает фото по ссылке

     - url: по какому url грузить изображение.
     */
    func loadImage(url: String) {
        DispatchQueue.main.async {
            self.Iconimage.loadImageUsingCacheWithURLString(url, placeHolder: UIImage())
        }
    }
    
    override func prepareForReuse() {
        NameLabel.text = ""
        smallLabel.text = ""
        Iconimage.image = UIImage()
    }

}
