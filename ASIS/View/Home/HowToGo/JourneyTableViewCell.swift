//
//  JourneyTableViewCell.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 29.07.2022.
//

import UIKit

class JourneyTableViewCell: UITableViewCell {
    
    var durationLabel:UILabel!
    
    var serviceNameInfoLabel:UILabel = {
       let label = UILabel()
        label.text = "Service Name: ".localized
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var serviceNameLabel:UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    var directionNameInfoLabel:UILabel = {
        let label = UILabel()
         label.text = "Destination: ".localized
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    var directionNameLabel:UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    static let identifier = "JourneyTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style:UITableViewCell.CellStyle, reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGray6
        durationLabel = UILabel()
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(durationLabel)
        contentView.addSubview(serviceNameInfoLabel)
        contentView.addSubview(directionNameInfoLabel)
        contentView.addSubview(serviceNameLabel)
        contentView.addSubview(directionNameLabel)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 100),
            
            serviceNameInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            serviceNameInfoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            serviceNameLabel.topAnchor.constraint(equalTo: serviceNameInfoLabel.topAnchor),
            serviceNameLabel.leadingAnchor.constraint(equalTo: serviceNameInfoLabel.trailingAnchor),
            
            directionNameInfoLabel.leadingAnchor.constraint(equalTo: serviceNameInfoLabel.leadingAnchor),
            directionNameInfoLabel.topAnchor.constraint(equalTo: serviceNameInfoLabel.bottomAnchor, constant: 5),
            directionNameLabel.topAnchor.constraint(equalTo: directionNameInfoLabel.topAnchor),
            directionNameLabel.leadingAnchor.constraint(equalTo: directionNameInfoLabel.trailingAnchor),
            
            durationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
