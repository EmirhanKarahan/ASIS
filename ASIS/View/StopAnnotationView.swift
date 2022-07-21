//
//  StopAnnotationView.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 21.07.2022.
//

import UIKit
import MapKit

final class StopAnnotationView: MKAnnotationView {

    var titleLabel:UILabel!

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = true
        
        configureTitleView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTitleView(){
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 10)
        titleLabel.text = (annotation?.title)!
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    

}
