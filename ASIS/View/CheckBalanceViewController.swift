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

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
   
    func configure(){
        view.backgroundColor = .white
        
        let cardIDLabel = UILabel()
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
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
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
        print("Check balance tapped")
    }

}
