//
//  DepartureTableViewCell.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 29.07.2022.
//

import UIKit

final class DepartureTableViewCell: UITableViewCell {
    
    var stopNameInfoLabel:UILabel = {
       let label = UILabel()
        label.text = "Stop Name: ".localized
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var stopNameLabel:UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    var timeInfoLabel:UILabel = {
        let label = UILabel()
         label.text = "Time: ".localized
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    var timeLabel:UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    var rightImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bus-stop"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    static let identifier = "DepartureTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style:UITableViewCell.CellStyle, reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGray6
        contentView.addSubview(stopNameInfoLabel)
        contentView.addSubview(stopNameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeInfoLabel)
        contentView.addSubview(rightImageView)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 100),
            
            stopNameInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stopNameInfoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            stopNameLabel.topAnchor.constraint(equalTo: stopNameInfoLabel.topAnchor),
            stopNameLabel.leadingAnchor.constraint(equalTo: stopNameInfoLabel.trailingAnchor),
            
            timeInfoLabel.leadingAnchor.constraint(equalTo: stopNameInfoLabel.leadingAnchor),
            timeInfoLabel.topAnchor.constraint(equalTo: stopNameInfoLabel.bottomAnchor, constant: 5),
            
            timeLabel.topAnchor.constraint(equalTo: timeInfoLabel.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: timeInfoLabel.trailingAnchor),
            
            rightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rightImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightImageView.widthAnchor.constraint(equalToConstant: 50),
            rightImageView.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
