//
//  RegisterViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit
import FirebaseAuth

final class RegisterViewController: UIViewController {
    
    private var signUpLabel:UILabel!
    private var emailLabel: UILabel!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var passwordLabel: UILabel!
    private var passwordAgainTextField: UITextField!
    private var passwordAgainLabel: UILabel!
    private var signUpButton:UIButton!
    private var errorLabel:UILabel!
    
    private var redirectToSignInButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        configure()
    }
    
    @objc func didTapSignUp(){
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let passwordAgain = passwordAgainTextField.text, !passwordAgain.isEmpty
        else {
            errorLabel.text = "Missing data"
            return
        }
        
        if password != passwordAgain {
            errorLabel.text = "Passwords aren't matching"
            return
        }

        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else {return}

            guard error == nil else {
                strongSelf.errorLabel.text = error?.localizedDescription
                return
            }

            UIApplication.shared.windows.first?.rootViewController = AppNavigationController()
        })
    }
    
    @objc func redirectToSignIn(){
        UIApplication.shared.windows.first?.rootViewController = LoginViewController()
    }

    
    func configure(){
        view.backgroundColor = .white
        
        signUpLabel = UILabel()
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.text = "Sign Up"
        signUpLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(signUpLabel)
        
        redirectToSignInButton = UIButton(type: .system)
        redirectToSignInButton.translatesAutoresizingMaskIntoConstraints = false
        redirectToSignInButton.setTitle("Do you have an account already?", for: .normal)
        redirectToSignInButton.addTarget(self, action: #selector(redirectToSignIn), for: .touchUpInside)
        view.addSubview(redirectToSignInButton)
    
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
        
        passwordAgainLabel = UILabel()
        passwordAgainLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordAgainLabel.text = "Password again"
        passwordAgainLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(passwordAgainLabel)
        
        passwordAgainTextField = UITextField()
        passwordAgainTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordAgainTextField.font = UIFont.systemFont(ofSize: 18)
        passwordAgainTextField.layer.borderWidth = 1
        passwordAgainTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordAgainTextField.autocapitalizationType = .none
        passwordAgainTextField.isSecureTextEntry = true
        passwordAgainTextField.layer.cornerRadius = 3
        view.addSubview(passwordAgainTextField)
        
        signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.layer.cornerRadius = 5
        signUpButton.backgroundColor = .orange
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            signUpLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            signUpLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: signUpLabel.topAnchor, constant: 50),
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
            
            passwordAgainLabel.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: 40),
            passwordAgainLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            
            passwordAgainTextField.topAnchor.constraint(equalTo: passwordAgainLabel.bottomAnchor, constant: 2),
            passwordAgainTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordAgainTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordAgainTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: passwordAgainTextField.bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: passwordAgainTextField.leadingAnchor),
            errorLabel.widthAnchor.constraint(equalTo: passwordAgainTextField.widthAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: passwordAgainTextField.bottomAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 100),
            
            redirectToSignInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 5),
            redirectToSignInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
        ])
        
    }
    
    
    
}
