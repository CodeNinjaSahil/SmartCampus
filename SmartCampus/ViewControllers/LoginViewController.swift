import UIKit

final class LoginViewController: UIViewController, UITextFieldDelegate {
    private let usernameField = UITextField.styled(placeholder: "Username")
    private let passwordField = UITextField.styled(placeholder: "Password")

    // Demo credentials (Phase 5.2)
    private let validUsername = "admin"
    private let validPassword = "1234"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let brand = UILabel()
        brand.text = "SMART CAMPUS"
        brand.font = .systemFont(ofSize: 14, weight: .semibold)
        brand.textColor = .secondaryLabel
        brand.textAlignment = .center

        let logo = UIImageView(image: UIImage(systemName: "building.columns.fill"))
        logo.tintColor = Theme.accent
        logo.contentMode = .scaleAspectFit
        logo.heightAnchor.constraint(equalToConstant: 90).isActive = true

        let welcome = UILabel()
        welcome.text = "Welcome Back"
        welcome.font = .systemFont(ofSize: 28, weight: .bold)
        welcome.textAlignment = .center

        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        usernameField.returnKeyType = .next
        usernameField.delegate = self

        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .go
        passwordField.delegate = self

        let loginButton = UIButton.primary("LOGIN")
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        let hint = UILabel()
        hint.text = "Demo login: admin / 1234"
        hint.font = .systemFont(ofSize: 12)
        hint.textColor = .tertiaryLabel
        hint.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [brand, logo, welcome, usernameField,
                                                   passwordField, loginButton, hint])
        stack.axis = .vertical
        stack.spacing = 16
        stack.setCustomSpacing(8, after: brand)
        stack.setCustomSpacing(28, after: welcome)
        stack.setCustomSpacing(24, after: passwordField)

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -30),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32)
        ])

        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }

    @objc private func loginTapped() {
        view.endEditing(true)
        let username = (usernameField.text ?? "").trimmed
        let password = passwordField.text ?? ""

        if username.isEmpty || password.isEmpty {
            showAlert(title: "Missing Details", message: "Please enter both username and password.")
        } else if username == validUsername && password == validPassword {
            switchRoot(to: MainTabBarController())
        } else {
            showAlert(title: "Login Failed", message: "Invalid username or password.")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        } else {
            loginTapped()
        }
        return true
    }
}
