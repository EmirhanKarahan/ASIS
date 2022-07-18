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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureResults()
    }
    
    func configureResults(){
        balanceLabel = UILabel()
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.text = "Balance:".localized
        balanceLabel.font = UIFont.systemFont(ofSize: 18)
        
        balanceResultLabel = UILabel()
        balanceResultLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceResultLabel.font = UIFont.systemFont(ofSize: 18)
       
        cardIDTextLabel = UILabel()
        cardIDTextLabel.translatesAutoresizingMaskIntoConstraints = false
        cardIDTextLabel.text = "Card ID:".localized
        cardIDTextLabel.font = UIFont.systemFont(ofSize: 18)
       
        cardIDResultLabel = UILabel()
        cardIDResultLabel.translatesAutoresizingMaskIntoConstraints = false
        cardIDResultLabel.font = UIFont.systemFont(ofSize: 18)
        
        lastUsageLabel = UILabel()
        lastUsageLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUsageLabel.text = "Last Usage:".localized
        lastUsageLabel.font = UIFont.systemFont(ofSize: 18)
       
        lastUsageResultLabel = UILabel()
        lastUsageResultLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUsageResultLabel.text = "19.05.2021 - Kutahya"
        lastUsageResultLabel.font = UIFont.systemFont(ofSize: 18)
        
        lastUsageResultLabel.isHidden = true
        balanceLabel.isHidden = true
        balanceResultLabel.isHidden = true
        cardIDTextLabel.isHidden = true
        cardIDResultLabel.isHidden = true
        lastUsageLabel.isHidden = true
        
        view.addSubview(lastUsageResultLabel)
        view.addSubview(balanceLabel)
        view.addSubview(balanceResultLabel)
        view.addSubview(cardIDTextLabel)
        view.addSubview(cardIDResultLabel)
        view.addSubview(lastUsageLabel)
        
        NSLayoutConstraint.activate([
            lastUsageLabel.bottomAnchor.constraint(equalTo: cardIDLabel.topAnchor, constant: -30),
            lastUsageLabel.leadingAnchor.constraint(equalTo: cardIDLabel.leadingAnchor, constant: 30),
            
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
            cardIDLabel.leadingAnchor.constraint(equalTo: cardIDTextField.leadingAnchor),
            cardIDLabel.bottomAnchor.constraint(equalTo: cardIDTextField.topAnchor),
            
            cardIDTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardIDTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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
        
        lastUsageResultLabel.isHidden = false
        balanceLabel.isHidden = false
        balanceResultLabel.isHidden = false
        cardIDTextLabel.isHidden = false
        cardIDResultLabel.isHidden = false
        lastUsageLabel.isHidden = false
        
        cardIDResultLabel.text = cardIDTextField.text
        balanceResultLabel.text = "\(String(format:"%.2f", Double.random(in: 10.0 ..< 20.0)))₺"
        
    }

}
