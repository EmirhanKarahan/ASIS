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
    private var passwordToggleButton:UIButton!
    private var passwordAgainToggleButton:UIButton!
    
    var gestureRecognizer = UITapGestureRecognizer()
    
    private var redirectToSignInButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up".localized
        configure()
    }
    
    @objc func didTapSignUp(){
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let passwordAgain = passwordAgainTextField.text, !passwordAgain.isEmpty
        else {
            errorLabel.text = "Missing data".localized
            return
        }
        
        if password != passwordAgain {
            errorLabel.text = "Passwords aren't matching".localized
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
    
    @objc func didTapTogglePassword(){
        if passwordTextField.isSecureTextEntry && passwordAgainTextField.isSecureTextEntry{
            passwordToggleButton.setImage(UIImage(named: "eye"), for: .normal)
            passwordAgainToggleButton.setImage(UIImage(named: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = false
            passwordAgainTextField.isSecureTextEntry = false
            return
        }
        
        passwordToggleButton.setImage(UIImage(named: "eye-closed"), for: .normal)
        passwordAgainToggleButton.setImage(UIImage(named: "eye-closed"), for: .normal)
        passwordTextField.isSecureTextEntry = true
        passwordAgainTextField.isSecureTextEntry = true
    }
    
    func assignbackground(){
          let background = UIImage(named: "background")
          var imageView : UIImageView!
          imageView = UIImageView(frame: view.bounds)
          imageView.contentMode =  UIView.ContentMode.scaleAspectFill
          imageView.clipsToBounds = true
          imageView.image = background
          imageView.center = view.center
          view.addSubview(imageView)
          self.view.sendSubviewToBack(imageView)
      }

    
    func configure(){
        view.backgroundColor = .white
        assignbackground()
        
        signUpLabel = UILabel()
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.text = "Register".localized
        signUpLabel.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.bold)
        signUpLabel.textColor = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1)
        view.addSubview(signUpLabel)
        
        redirectToSignInButton = UIButton(type: .system)
        redirectToSignInButton.translatesAutoresizingMaskIntoConstraints = false
        redirectToSignInButton.setTitleColor(.white, for: .normal)
        redirectToSignInButton.setTitle("Already Member? Login".localized, for: .normal)
        redirectToSignInButton.addTarget(self, action: #selector(redirectToSignIn), for: .touchUpInside)
        view.addSubview(redirectToSignInButton)
    
        errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = UIFont.systemFont(ofSize: 16)
        errorLabel.textColor = UIColor(red: 250/255, green: 70/255, blue: 22/255, alpha: 1)
        view.addSubview(errorLabel)
        
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = "Email".localized
        emailLabel.font = UIFont.systemFont(ofSize: 16)
        emailLabel.textColor = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1)
        view.addSubview(emailLabel)
        

        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.font = UIFont.systemFont(ofSize: 18)
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1).cgColor
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.layer.cornerRadius = 6
        view.addSubview(emailTextField)
        
        passwordLabel = UILabel()
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.text = "Password".localized
        passwordLabel.font = UIFont.systemFont(ofSize: 16)
        passwordLabel.textColor = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1)
        view.addSubview(passwordLabel)
        
        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.font = UIFont.systemFont(ofSize: 18)
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1).cgColor
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.cornerRadius = 6
        view.addSubview(passwordTextField)
        
        passwordAgainLabel = UILabel()
        passwordAgainLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordAgainLabel.text = "Password again".localized
        passwordAgainLabel.font = UIFont.systemFont(ofSize: 16)
        passwordAgainLabel.textColor = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1)
        view.addSubview(passwordAgainLabel)
        
        passwordAgainTextField = UITextField()
        passwordAgainTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordAgainTextField.font = UIFont.systemFont(ofSize: 18)
        passwordAgainTextField.layer.borderWidth = 1
        passwordAgainTextField.layer.borderColor = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1).cgColor
        passwordAgainTextField.autocapitalizationType = .none
        passwordAgainTextField.isSecureTextEntry = true
        passwordAgainTextField.layer.cornerRadius = 6
        view.addSubview(passwordAgainTextField)
        
        passwordToggleButton = UIButton()
        passwordToggleButton.translatesAutoresizingMaskIntoConstraints = false
        passwordToggleButton.setImage(UIImage(named: "eye-closed"), for: .normal)
        passwordToggleButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        passwordToggleButton.addTarget(self, action: #selector(didTapTogglePassword), for: .touchUpInside)
        view.addSubview(passwordToggleButton)
        
        passwordAgainToggleButton = UIButton()
        passwordAgainToggleButton.translatesAutoresizingMaskIntoConstraints = false
        passwordAgainToggleButton.setImage(UIImage(named: "eye-closed"), for: .normal)
        passwordAgainToggleButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        passwordAgainToggleButton.addTarget(self, action: #selector(didTapTogglePassword), for: .touchUpInside)
        view.addSubview(passwordAgainToggleButton)
        
        signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signUpButton.setTitle("Register".localized, for: .normal)
        signUpButton.layer.cornerRadius = 6
        signUpButton.backgroundColor = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1)
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.borderWidth = 1
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            signUpLabel.bottomAnchor.constraint(equalTo: emailLabel.topAnchor, constant: -40),
            signUpLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -4),
            emailLabel.leadingAnchor.constraint(equalTo: signUpLabel.leadingAnchor),
            
            emailTextField.bottomAnchor.constraint(equalTo: passwordLabel.topAnchor, constant: -19),
            emailTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 309),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -4),
            passwordLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            
            passwordTextField.bottomAnchor.constraint(equalTo: passwordAgainLabel.topAnchor, constant: -19),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordLabel.leadingAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            passwordAgainLabel.bottomAnchor.constraint(equalTo: passwordAgainTextField.topAnchor, constant: -4),
            passwordAgainLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            
            passwordAgainTextField.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -100),
            passwordAgainTextField.leadingAnchor.constraint(equalTo: passwordAgainLabel.leadingAnchor),
            passwordAgainTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordAgainTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            passwordToggleButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            passwordToggleButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            
            passwordAgainToggleButton.trailingAnchor.constraint(equalTo: passwordAgainTextField.trailingAnchor),
            passwordAgainToggleButton.centerYAnchor.constraint(equalTo: passwordAgainTextField.centerYAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: passwordAgainTextField.bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: passwordAgainTextField.leadingAnchor),
            errorLabel.widthAnchor.constraint(equalTo: passwordAgainTextField.widthAnchor),
            
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            signUpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            signUpButton.widthAnchor.constraint(equalToConstant: 130),
            signUpButton.heightAnchor.constraint(equalToConstant: 60),
            
            redirectToSignInButton.bottomAnchor.constraint(equalTo: signUpButton.bottomAnchor),
            redirectToSignInButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            
        ])
        
    }
    
}
