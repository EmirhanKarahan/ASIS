//
//  LoginViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit
import FirebaseAuth
import Alamofire

final class LoginViewController: UIViewController {
    
    private var signInLabel:UILabel!
    private var emailLabel: UILabel!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var passwordLabel: UILabel!
    private var signInButton:UIButton!
    private var errorLabel:UILabel!
    private var passwordToggleButton:UIButton!
    private var redirectToSignUpButton:UIButton!
    
    var gestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In".localized
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !(NetworkReachabilityManager()?.isReachable ?? false){
            let ac = UIAlertController(title: "Network connection missing", message: "Please, connect to a network", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok".localized, style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func didTapSignIn(){
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = "Missing data".localized
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
    
    @objc func didTapTogglePassword(){
        if passwordTextField.isSecureTextEntry {
            passwordToggleButton.setImage(UIImage(named: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = false
            return
        }
        passwordToggleButton.setImage(UIImage(named: "eye-closed"), for: .normal)
        passwordTextField.isSecureTextEntry = true
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
        
        signInLabel = UILabel()
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.text = "Login".localized
        signInLabel.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.bold)
        signInLabel.textColor = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1)
        view.addSubview(signInLabel)
        
        redirectToSignUpButton = UIButton(type: .system)
        redirectToSignUpButton.translatesAutoresizingMaskIntoConstraints = false
        redirectToSignUpButton.setTitleColor(.white, for: .normal)
        redirectToSignUpButton.setTitle("New Here? Register".localized, for: .normal)
        redirectToSignUpButton.addTarget(self, action: #selector(redirectToSignUp), for: .touchUpInside)
        view.addSubview(redirectToSignUpButton)
    
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
        emailTextField.layer.cornerRadius = 8
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
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1).cgColor
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.cornerRadius = 8
        view.addSubview(passwordTextField)
        
        passwordToggleButton = UIButton()
        passwordToggleButton.translatesAutoresizingMaskIntoConstraints = false
        passwordToggleButton.setImage(UIImage(named: "eye-closed"), for: .normal)
        passwordToggleButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        passwordToggleButton.addTarget(self, action: #selector(didTapTogglePassword), for: .touchUpInside)
        view.addSubview(passwordToggleButton)
    
        signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signInButton.setTitle("Login".localized, for: .normal)
        signInButton.layer.cornerRadius = 6
        signInButton.backgroundColor = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1)
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            signInLabel.bottomAnchor.constraint(equalTo: emailLabel.topAnchor, constant: -40),
            signInLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -4),
            emailLabel.leadingAnchor.constraint(equalTo: signInLabel.leadingAnchor),
            
            emailTextField.bottomAnchor.constraint(equalTo: passwordLabel.topAnchor, constant: -19),
            emailTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 309),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -4),
            passwordLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            
            passwordTextField.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -100),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordLabel.leadingAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            passwordToggleButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            passwordToggleButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            errorLabel.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
            
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            signInButton.widthAnchor.constraint(equalToConstant: 130),
            signInButton.heightAnchor.constraint(equalToConstant: 60),
            
            redirectToSignUpButton.bottomAnchor.constraint(equalTo: signInButton.bottomAnchor),
            redirectToSignUpButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
        ])
        
    }
    
}
