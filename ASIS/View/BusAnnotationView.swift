//
//  BusAnnotationView.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 21.07.2022.
//

import UIKit
import MapKit

class BusAnnotationView: MKAnnotationView {
    var titleLabel:UILabel!
    var observer: NSKeyValueObservation!

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = true
        configureTitleView()
        configureAngleObserver()
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
    
    private func configureAngleObserver() {
        if let annotation = annotation as? BusAnnotation {
            observer = annotation.observe(\.angle) { [unowned self] annotation, _ in
                self.image = UIImage(named: "arrow")?.rotate(angle: annotation.angle)
            }
        }
    }
    
//    private func configureAnimations(){
//        let breathAnimation = CABasicAnimation(keyPath: "opacity")
//        breathAnimation.fromValue = 0.7
//        breathAnimation.toValue = 1
//
//        let animations = CAAnimationGroup()
//        animations.duration = 0.5
//        animations.repeatCount = .infinity
//        animations.animations = [breathAnimation]
//
//      //  self.layer.add(animations, forKey: "animations")
//        self.layer.add(animations, forKey: nil)
//    }
//
  
}
