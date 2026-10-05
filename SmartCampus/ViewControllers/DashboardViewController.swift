import UIKit

final class DashboardViewController: UIViewController {
    private let greetingLabel = UILabel()
    private let todayValue = UILabel()
    private let activeValue = UILabel()
    private let recentStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let stack = makeScrollingStack(spacing: 16)

        greetingLabel.font = .systemFont(ofSize: 26, weight: .bold)
        let role = UILabel()
        role.text = "Security Officer"
        role.textColor = .secondaryLabel

        let cards = UIStackView(arrangedSubviews: [
            statCard(title: "Today's Visitors", value: todayValue, symbol: "person.2.fill"),
            statCard(title: "Active Visitors", value: activeValue, symbol: "checkmark.seal.fill")
        ])
        cards.axis = .horizontal
        cards.spacing = 12
        cards.distribution = .fillEqually

        let registerButton = UIButton.primary("+  Register Visitor")
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        let scanButton = UIButton.primary("Scan Visitor Pass", color: .systemTeal)
        scanButton.addTarget(self, action: #selector(scanTapped), for: .touchUpInside)

        let recentTitle = UILabel()
        recentTitle.text = "Recent Visitors"
        recentTitle.font = .systemFont(ofSize: 20, weight: .semibold)

        recentStack.axis = .vertical
        recentStack.spacing = 14

        [greetingLabel, role, cards, registerButton, scanButton, recentTitle, recentStack]
            .forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(4, after: greetingLabel)
        stack.setCustomSpacing(24, after: scanButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    private func refresh() {
        let hour = Calendar.current.component(.hour, from: Date())
        let part = hour < 12 ? "Morning" : (hour < 17 ? "Afternoon" : "Evening")
        greetingLabel.text = "Good \(part) 👋"

        let store = VisitorStore.shared
        todayValue.text = "\(store.todayCount)"
        activeValue.text = "\(store.activeCount)"

        recentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for v in store.visitors.reversed().prefix(5) {
            let name = UILabel()
            name.text = v.name
            name.font = .systemFont(ofSize: 16, weight: .medium)
            let status = UILabel()
            status.text = "● \(v.status.rawValue)"
            status.font = .systemFont(ofSize: 13, weight: .semibold)
            status.textColor = v.status.color
            status.setContentHuggingPriority(.required, for: .horizontal)
            let row = UIStackView(arrangedSubviews: [name, status])
            row.axis = .horizontal
            recentStack.addArrangedSubview(row)
        }
    }

    private func statCard(title: String, value: UILabel, symbol: String) -> UIView {
        let card = UIView()
        card.styleAsCard()

        let icon = UIImageView(image: UIImage(systemName: symbol))
        icon.tintColor = Theme.accent
        icon.contentMode = .scaleAspectFit
        icon.heightAnchor.constraint(equalToConstant: 26).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 30).isActive = true

        value.font = .systemFont(ofSize: 34, weight: .bold)
        let caption = UILabel()
        caption.text = title
        caption.font = .systemFont(ofSize: 13)
        caption.textColor = .secondaryLabel

        let inner = UIStackView(arrangedSubviews: [icon, value, caption])
        inner.axis = .vertical
        inner.alignment = .leading
        inner.spacing = 4
        card.addSubview(inner)
        inner.pin(to: card, insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        return card
    }

    @objc private func registerTapped() {
        navigationController?.pushViewController(RegisterVisitorViewController(), animated: true)
    }

    @objc private func scanTapped() {
        tabBarController?.selectedIndex = 2
    }
}
