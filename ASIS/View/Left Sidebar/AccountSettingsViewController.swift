//
//  AccountSettingsViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit
import FirebaseAuth

final class AccountSettingsViewController: UIViewController {
    
    private var emailLabel:UILabel!
    private var emailTextField:UITextField!
    private var passwordLabel:UILabel!
    private var passwordTextField:UITextField!
    private var currentUser:User!
    
    private var resetPasswordButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure(){
        title = "Account Settings".localized
        view.backgroundColor = .white
    
        currentUser = FirebaseAuth.Auth.auth().currentUser
        
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = "Email".localized
        emailLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(emailLabel)
        
        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.font = UIFont.systemFont(ofSize: 18)
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.placeholder = currentUser.email
        emailTextField.setLeftPaddingPoints(5)
        emailTextField.isUserInteractionEnabled = false
        emailTextField.layer.cornerRadius = 3
        view.addSubview(emailTextField)
        
        passwordLabel = UILabel()
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.text = "Password".localized
        passwordLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(passwordLabel)
        
        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.font = UIFont.systemFont(ofSize: 18)
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.placeholder = "**********"
        passwordTextField.setLeftPaddingPoints(5)
        passwordTextField.isUserInteractionEnabled = false
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.cornerRadius = 3
        view.addSubview(passwordTextField)
        
        resetPasswordButton = UIButton()
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        resetPasswordButton.setTitle("Reset Password".localized, for: .normal)
        resetPasswordButton.layer.cornerRadius = 5
        resetPasswordButton.backgroundColor = .orange
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordClicked), for: .touchUpInside)
        view.addSubview(resetPasswordButton)
        
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 2),
            emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 30),
            
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 40),
            passwordLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 2),
            passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            resetPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            resetPasswordButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            resetPasswordButton.widthAnchor.constraint(equalToConstant: 150)
            
        ])
        
    }
    
    @objc func resetPasswordClicked(){
        guard let email = currentUser.email else { return }
        
        FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email)
        let ac = UIAlertController(title: "Success", message: "We sent you and email", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok".localized, style: .default){ _ in
            do {
                try FirebaseAuth.Auth.auth().signOut()
                UIApplication.shared.windows.first?.rootViewController = LoginViewController()
                print("Signed out")
            } catch {
                print("Couldn't sign out, error occured")
            }
        })
        present(ac, animated: true)
        
        
        
    }
    
    
}
