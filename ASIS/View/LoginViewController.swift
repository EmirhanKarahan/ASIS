//
//  LoginViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    private var signInLabel:UILabel!
    private var emailLabel: UILabel!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var passwordLabel: UILabel!
    private var signInButton:UIButton!
    private var errorLabel:UILabel!
    
    private var redirectToSignUpButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        configure()
    }
    
    @objc func didTapSignIn(){
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = "Missing data"
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else {return}
            
            guard error == nil else {
                strongSelf.errorLabel.text = error?.localizedDescription
                return
            }
            
            UIApplication.shared.windows.first?.rootViewController = AppNavigationController()
        })
    }
    
    @objc func redirectToSignUp(){
        UIApplication.shared.windows.first?.rootViewController = RegisterViewController()
    }

    
    func configure(){
        view.backgroundColor = .white
        
        signInLabel = UILabel()
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.text = "Sign In"
        signInLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(signInLabel)
        
        redirectToSignUpButton = UIButton(type: .system)
        redirectToSignUpButton.translatesAutoresizingMaskIntoConstraints = false
        redirectToSignUpButton.setTitle("Don't you have an account?", for: .normal)
        redirectToSignUpButton.addTarget(self, action: #selector(redirectToSignUp), for: .touchUpInside)
        view.addSubview(redirectToSignUpButton)
    
        errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = UIFont.systemFont(ofSize: 14)
        errorLabel.textColor = .red
        view.addSubview(errorLabel)
        
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = "Email"
        emailLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(emailLabel)
        
        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.font = UIFont.systemFont(ofSize: 18)
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.layer.cornerRadius = 3
        view.addSubview(emailTextField)
        
        passwordLabel = UILabel()
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(passwordLabel)
        
        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.font = UIFont.systemFont(ofSize: 18)
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.cornerRadius = 3
        view.addSubview(passwordTextField)
        
        signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.layer.cornerRadius = 5
        signInButton.backgroundColor = .orange
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            signInLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            signInLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: signInLabel.topAnchor, constant: 50),
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
            
            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            errorLabel.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            signInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 100),
            
            redirectToSignUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 5),
            redirectToSignUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
        ])
        
    }
    
    
    
}
