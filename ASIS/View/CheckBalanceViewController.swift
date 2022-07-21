//
//  CheckBalanceViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit

final class CheckBalanceViewController: UIViewController {
    
    let helper = NFCHelper()
    var cardIDTextField:UITextField!
    var cardIDLabel:UILabel!
    
    var balanceLabel: UILabel!
    var balanceResultLabel : UILabel!
    var cardIDTextLabel : UILabel!
    var cardIDResultLabel : UILabel!
    var lastUsageLabel : UILabel!
    var lastUsageResultLabel : UILabel!
    var imageView: UIImage!
    var cardImageView: UIImageView!
    
    let randomCities = ["Kutahya", "Izmir", "Erzincan", "Manisa", "Eskişehir", "Bursa", "Diyarbakır", "Burdur", "Kocaeli", "Afyon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureResults()
        configure()
    }
    
    func configureResults() {
        cardImageView = UIImageView()
        cardImageView.image = UIImage(named: "credit-card")
        cardImageView.contentMode = .scaleAspectFill
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        
        balanceLabel = UILabel()
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.text = "Balance:".localized
        balanceLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        balanceLabel.textColor = .white
        
        balanceResultLabel = UILabel()
        balanceResultLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceResultLabel.font = UIFont.systemFont(ofSize: 12)
       
        cardIDTextLabel = UILabel()
        cardIDTextLabel.translatesAutoresizingMaskIntoConstraints = false
        cardIDTextLabel.text = "Card ID:".localized
        cardIDTextLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        cardIDTextLabel.textColor = .white
       
        cardIDResultLabel = UILabel()
        cardIDResultLabel.translatesAutoresizingMaskIntoConstraints = false
        cardIDResultLabel.font = UIFont.systemFont(ofSize: 12)
        
        lastUsageLabel = UILabel()
        lastUsageLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUsageLabel.text = "Last Usage:".localized
        lastUsageLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lastUsageLabel.textColor = .white
       
        lastUsageResultLabel = UILabel()
        lastUsageResultLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUsageResultLabel.font = UIFont.systemFont(ofSize: 12)
        
        cardImageView.isHidden = true
        lastUsageResultLabel.isHidden = true
        balanceLabel.isHidden = true
        balanceResultLabel.isHidden = true
        cardIDTextLabel.isHidden = true
        cardIDResultLabel.isHidden = true
        lastUsageLabel.isHidden = true
        
        view.addSubview(cardImageView)
        cardImageView.addSubview(lastUsageResultLabel)
        cardImageView.addSubview(balanceLabel)
        cardImageView.addSubview(balanceResultLabel)
        cardImageView.addSubview(cardIDTextLabel)
        cardImageView.addSubview(cardIDResultLabel)
        cardImageView.addSubview(lastUsageLabel)
        
        NSLayoutConstraint.activate([
            lastUsageLabel.bottomAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 0),
            lastUsageLabel.leadingAnchor.constraint(equalTo: cardImageView.leadingAnchor, constant: 10),
            
            lastUsageResultLabel.leadingAnchor.constraint(equalTo: lastUsageLabel.trailingAnchor, constant: 5),
            lastUsageResultLabel.centerYAnchor.constraint(equalTo: lastUsageLabel.centerYAnchor),
            
            cardIDTextLabel.bottomAnchor.constraint(equalTo: lastUsageLabel.topAnchor, constant: -15),
            cardIDTextLabel.leadingAnchor.constraint(equalTo: lastUsageLabel.leadingAnchor),
            
            cardIDResultLabel.leadingAnchor.constraint(equalTo: cardIDTextLabel.trailingAnchor, constant: 5),
            cardIDResultLabel.centerYAnchor.constraint(equalTo: cardIDTextLabel.centerYAnchor),
            
            balanceLabel.bottomAnchor.constraint(equalTo: cardIDTextLabel.topAnchor, constant: -15),
            balanceLabel.leadingAnchor.constraint(equalTo: cardIDTextLabel.leadingAnchor),
            
            balanceResultLabel.leadingAnchor.constraint(equalTo: balanceLabel.trailingAnchor, constant: 5),
            balanceResultLabel.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor),
        ])
    }
    
    func configure(){
        view.backgroundColor = .white
        
        cardIDLabel = UILabel()
        cardIDLabel.translatesAutoresizingMaskIntoConstraints = false
        cardIDLabel.textAlignment = .right
        cardIDLabel.text = "Card Number".localized
        cardIDLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(cardIDLabel)
        
        cardIDTextField = UITextField()
        cardIDTextField.translatesAutoresizingMaskIntoConstraints = false
        cardIDTextField.placeholder = "Please, type your card id or scan it".localized
        cardIDTextField.textAlignment = .center
        cardIDTextField.font = UIFont.systemFont(ofSize: 20)
        cardIDTextField.autocorrectionType = .no
        cardIDTextField.autocapitalizationType = .none
        cardIDTextField.layer.borderColor = UIColor.lightGray.cgColor
        cardIDTextField.layer.borderWidth = 1
        cardIDTextField.layer.cornerRadius = 5
        view.addSubview(cardIDTextField)
        
        let scanNFCButton = UIButton(type: .system)
        scanNFCButton.translatesAutoresizingMaskIntoConstraints = false
        scanNFCButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        scanNFCButton.setTitle("Fill with NFC scanning".localized, for: .normal)
        view.addSubview(scanNFCButton)
        scanNFCButton.addTarget(self, action: #selector(didScanNFCTapped), for: .touchUpInside)
        
        let checkBalanceButton = UIButton(type: .system)
        checkBalanceButton.backgroundColor = .systemGreen
        checkBalanceButton.translatesAutoresizingMaskIntoConstraints = false
        checkBalanceButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        checkBalanceButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        checkBalanceButton.tintColor = .white
        checkBalanceButton.layer.cornerRadius = 5
        checkBalanceButton.setTitle("Check balance".localized, for: .normal)
        view.addSubview(checkBalanceButton)
        checkBalanceButton.addTarget(self, action: #selector(didCheckBalanceTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            cardImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            cardImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.7),
            cardImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height * 0.2),
            
            cardIDLabel.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant:40),
            cardIDLabel.leadingAnchor.constraint(equalTo: cardIDTextField.leadingAnchor),
            
            cardIDTextField.topAnchor.constraint(equalTo: cardIDLabel.bottomAnchor),
            cardIDTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardIDTextField.heightAnchor.constraint(equalToConstant: 40),
            cardIDTextField.widthAnchor.constraint(equalToConstant: 350),
            
            scanNFCButton.centerXAnchor.constraint(equalTo: view.centerXAnchor ),
            scanNFCButton.centerYAnchor.constraint(equalTo: cardIDTextField.bottomAnchor, constant: 10),
            
            checkBalanceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkBalanceButton.centerYAnchor.constraint(equalTo: scanNFCButton.bottomAnchor, constant: 30),
            checkBalanceButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        
    }
    
    func onNFCResult(success:Bool, msg:String){
        DispatchQueue.main.async {
            self.cardIDTextField.text = msg
        }
    }
    
    @objc func didScanNFCTapped(){
        cardIDTextField.endEditing(true)
        do {
            helper.onNFCResult = onNFCResult(success:msg:)
            try helper.restartSession()
        } catch NFCError.deviceNotSupported{
            let alertController = UIAlertController(
                title: "Scanning Not Supported".localized,
                message: "This device doesn't support tag scanning.".localized,
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    @objc func didCheckBalanceTapped(){
        cardIDTextField.endEditing(true)
        
        if cardIDTextField.text == "" {
            cardIDLabel.text = "Card Number !".localized
            return
        }
        
        cardImageView.isHidden = false
        lastUsageResultLabel.isHidden = false
        balanceLabel.isHidden = false
        balanceResultLabel.isHidden = false
        cardIDTextLabel.isHidden = false
        cardIDResultLabel.isHidden = false
        lastUsageLabel.isHidden = false
        
        cardIDResultLabel.text = cardIDTextField.text
        balanceResultLabel.text = "\(String(format:"%.2f", Double.random(in: 10.0...20.0)))₺"
        lastUsageResultLabel.text = "\(Int.random(in: 1...30)).\(Int.random(in: 1...12)).20\(Int.random(in: 18...22)) - \(randomCities[Int.random(in: 0...randomCities.count-1)])"
        
    }

}
