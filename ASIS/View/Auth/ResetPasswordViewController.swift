//
//  ResetPasswordViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 21.07.2022.
//

import UIKit
import FirebaseAuth

final class ResetPasswordViewController: UIViewController {
    private var titleLabel:UILabel!
    
    private var mailLabel:UILabel!
    private var mailTextField:UITextField!
    
    private var resetPasswordButton:UIButton!
    private var cancelButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.text = "Reset Password".localized
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        mailLabel = UILabel()
        mailLabel.text = "Your Email".localized
        mailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mailLabel)
        
        mailTextField = UITextField()
        mailTextField.layer.cornerRadius = mailTextField.frame.size.height/2
        mailTextField.clipsToBounds = false
        mailTextField.layer.shadowOpacity = 0.4
        mailTextField.layer.shadowOffset = CGSize(width: 0, height: 0)
        mailTextField.layer.borderWidth = 1.0
        mailTextField.layer.borderColor = UIColor(white: 0.5, alpha: 0.3).cgColor
        mailTextField.layer.cornerRadius = 5
        mailTextField.setHorizonzalPaddingPoints(5)
        mailTextField.autocorrectionType = .no
        mailTextField.autocapitalizationType = .none
        mailTextField.keyboardType = .emailAddress
        mailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mailTextField)
        
        resetPasswordButton = UIButton()
        resetPasswordButton.setTitle("Reset".localized, for: .normal)
        resetPasswordButton.layer.cornerRadius = 5
        resetPasswordButton.backgroundColor = .systemGreen
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(resetPasswordButton)
        
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel".localized, for: .normal)
        cancelButton.backgroundColor = .systemGray6
        cancelButton.layer.cornerRadius = 5
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
    
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            mailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            mailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            mailTextField.topAnchor.constraint(equalTo: mailLabel.bottomAnchor, constant: 4),
            mailTextField.leadingAnchor.constraint(equalTo: mailLabel.leadingAnchor),
            mailTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -30),
            mailTextField.heightAnchor.constraint(equalToConstant: 36),
            
            resetPasswordButton.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 15),
            resetPasswordButton.trailingAnchor.constraint(equalTo: mailTextField.trailingAnchor),
            resetPasswordButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            
            cancelButton.topAnchor.constraint(equalTo: resetPasswordButton.topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: mailTextField.leadingAnchor),
            cancelButton.widthAnchor.constraint(equalTo: resetPasswordButton.widthAnchor),
        ])
    }
    
    @objc func cancelButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc func saveButtonTapped(){
        if !validateEmail(candidate: mailTextField.text!) {
            let ac = UIAlertController(title: "Failure".localized, message: "Badly formatted email adress", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok".localized, style: .default))
            present(ac, animated: true)
            return
        }
        let ac = UIAlertController(title: "Success".localized, message: "We sent you and email if your email adress is in our system", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok".localized, style: .default){ _ in
            FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: self.mailTextField.text!)
            self.dismiss(animated: true)
        })
        present(ac, animated: true)
    }
    
    private func validateEmail(candidate: String) -> Bool {
     let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
     return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
}
