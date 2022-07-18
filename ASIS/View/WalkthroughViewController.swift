//
//  WalkthroughViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 7.07.2022.
//

import UIKit
import Gifu

class WalkthroughViewController: UIViewController {
    private var imageView:UIImageView!
    private var fromleftSwipeRecognizer:UISwipeGestureRecognizer!
    private var fromRightSwipeRecognizer:UISwipeGestureRecognizer!
    private var walkthroughTitleLabel:UILabel!
    private var walkthroughInfoLabel:UILabel!
    private var gifView:GIFImageView!
    private var slideGifView:GIFImageView!
    private var numberOfSwipes = 0
    var backgroundImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @objc func swipedFromLeft(gesture: UISwipeGestureRecognizer){
        if gesture.direction == .left, numberOfSwipes < 6{
            numberOfSwipes += 1
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.imageView.transform = CGAffineTransform(translationX: -20, y: 0)
                self.imageView.alpha = 0.1
                self.gifView.transform = CGAffineTransform(translationX: -20, y: 0)
                self.gifView.alpha = 0.1
                self.walkthroughTitleLabel.alpha = 0.1
                self.walkthroughInfoLabel.alpha = 0.1
            }, completion: { _ in
                self.updateImage()
            })
        }
     
    }
    
    @objc func swipedFromRight(gesture: UISwipeGestureRecognizer){
        if gesture.direction == .right, numberOfSwipes > 0{
            numberOfSwipes -= 1
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.imageView.transform = CGAffineTransform(translationX: 20, y: 0)
                self.imageView.alpha = 0.1
                self.gifView.transform = CGAffineTransform(translationX: 20, y: 0)
                self.gifView.alpha = 0.1
                self.walkthroughTitleLabel.alpha = 0.1
                self.walkthroughInfoLabel.alpha = 0.1
            }, completion: { _ in
                self.updateImage()
            })
        }
       

    }
    
    func updateImage(){
        self.imageView.transform = CGAffineTransform(translationX: 0, y: 0)
        self.imageView.alpha = 1
        self.gifView.transform = CGAffineTransform(translationX: 0, y: 0)
        self.gifView.alpha = 1
        self.walkthroughTitleLabel.alpha = 1
        self.walkthroughInfoLabel.alpha = 1
        switch numberOfSwipes {
        case 0:
            imageView.image = nil
            gifView.animate(withGIFNamed: "balloons-animated")
            walkthroughInfoLabel.text = "Welcome to ASIS Demo, swipe left to discover amazing features".localized
            walkthroughTitleLabel.text = "Welcome".localized
        case 1:
            imageView.image = UIImage(named: "Walk 1")
            gifView.animate(withGIFNamed: "home-animated")
            walkthroughInfoLabel.text = "You can see your current location on the map".localized
            walkthroughTitleLabel.text = "Homepage".localized
        case 2:
            imageView.image = UIImage(named:"Walk 2")
            gifView.animate(withGIFNamed: "school-bus-animated")
            walkthroughInfoLabel.text = "You can see bus stops on the map".localized
            walkthroughTitleLabel.text = "Bus Stops".localized
        case 3:
            imageView.image = UIImage(named:"Walk 3")
            gifView.animate(withGIFNamed: "balance-animated")
            walkthroughInfoLabel.text = "You can see your card balance".localized
            walkthroughTitleLabel.text = "Balance".localized
        case 4:
            imageView.image = UIImage(named:"Walk 4")
            gifView.animate(withGIFNamed: "route-animated")
            walkthroughInfoLabel.text = "You can list all routes and see details about them".localized
            walkthroughTitleLabel.text = "Routes".localized
        case 5:
            imageView.image = UIImage(named:"Walk 5")
            gifView.animate(withGIFNamed: "bus-animated")
            walkthroughInfoLabel.text = "You can see live bus locations".localized
            walkthroughTitleLabel.text = "Bus Locations".localized
        case 6:
            UserDefaults.standard.set(true, forKey: "isWalkthroughSeenBefore")
            UIApplication.shared.windows.first?.rootViewController = LoginViewController()
        default:
            return
        }
    }
    
    private func configure(){
        view.backgroundColor = .white
        
        walkthroughTitleLabel = UILabel()
        walkthroughTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        walkthroughTitleLabel.text = "Welcome".localized
        walkthroughTitleLabel.textAlignment = .center
        walkthroughTitleLabel.font = .systemFont(ofSize: 36, weight: .semibold)
        view.addSubview(walkthroughTitleLabel)
        
        imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size.width = 400
        imageView.frame.size.height = 400
        imageView.image = nil
        view.addSubview(imageView)
        
        gifView = GIFImageView()
        gifView.translatesAutoresizingMaskIntoConstraints = false
        gifView.animate(withGIFNamed: "balloons-animated")
        view.addSubview(gifView)
        
        slideGifView = GIFImageView()
        slideGifView.translatesAutoresizingMaskIntoConstraints = false
        slideGifView.animate(withGIFNamed: "slide-animated")
        view.addSubview(slideGifView)
        
        walkthroughInfoLabel = UILabel()
        walkthroughInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        walkthroughInfoLabel.text = "Welcome to ASIS Demo, swipe left to discover amazing features".localized
        walkthroughInfoLabel.numberOfLines = 3
        walkthroughInfoLabel.textAlignment = .center
        walkthroughInfoLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        view.addSubview(walkthroughInfoLabel)
        
        fromleftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedFromLeft))
        fromleftSwipeRecognizer.direction = .left
        view.addGestureRecognizer(fromleftSwipeRecognizer)
        
        fromRightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedFromRight))
        fromRightSwipeRecognizer.direction = .right
        view.addGestureRecognizer(fromRightSwipeRecognizer)
        
        NSLayoutConstraint.activate([
            walkthroughTitleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -10),
            walkthroughTitleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 400),
            
            gifView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            gifView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            gifView.widthAnchor.constraint(equalToConstant: 100),
            gifView.heightAnchor.constraint(equalToConstant: 100),
            
            slideGifView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            slideGifView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            slideGifView.widthAnchor.constraint(equalToConstant: 50),
            slideGifView.heightAnchor.constraint(equalToConstant: 50),
            
            walkthroughInfoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            walkthroughInfoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            walkthroughInfoLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -50)
            
        ])
        
        
    }
   

}
