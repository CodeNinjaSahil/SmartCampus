import UIKit

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let stack = makeScrollingStack(spacing: 18, margins: 24)

        let icon = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        icon.tintColor = Theme.accent
        icon.contentMode = .scaleAspectFit
        icon.heightAnchor.constraint(equalToConstant: 100).isActive = true

        let name = UILabel()
        name.text = "Security Officer"
        name.font = .systemFont(ofSize: 24, weight: .bold)
        name.textAlignment = .center

        let info = UIStackView(arrangedSubviews: [
            infoRow("Username", "admin"),
            infoRow("Role", "Security Staff"),
            infoRow("App Version", "1.0")
        ])
        info.axis = .vertical
        info.spacing = 14
        info.isLayoutMarginsRelativeArrangement = true
        info.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        info.styleAsCard()

        let logout = UIButton.primary("Logout", color: .systemRed)
        logout.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        [icon, name, info, logout].forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(28, after: info)
    }

    private func infoRow(_ title: String, _ value: String) -> UIView {
        let t = UILabel()
        t.text = title
        t.textColor = .secondaryLabel
        let v = UILabel()
        v.text = value
        v.font = .systemFont(ofSize: 17, weight: .semibold)
        v.textAlignment = .right
        let row = UIStackView(arrangedSubviews: [t, v])
        row.axis = .horizontal
        return row
    }

    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Logout", message: "Do you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            self?.switchRoot(to: LoginViewController())
        })
        present(alert, animated: true)
    }
}
