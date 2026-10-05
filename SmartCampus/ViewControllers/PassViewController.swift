import UIKit

final class PassViewController: UIViewController {
    private let nameLabel = UILabel()
    private let hostValue = UILabel()
    private let departmentValue = UILabel()
    private let purposeValue = UILabel()
    private let dateValue = UILabel()
    private let passIDValue = UILabel()
    private let statusLabel = UILabel()
    private let qrImageView = UIImageView()
    private let card = UIView()
    private let emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let outer = makeScrollingStack(spacing: 0)

        let brand = UILabel()
        brand.text = "SMART CAMPUS"
        brand.font = .systemFont(ofSize: 13, weight: .bold)
        brand.textColor = Theme.accent
        let heading = UILabel()
        heading.text = "VISITOR PASS"
        heading.font = .systemFont(ofSize: 22, weight: .heavy)

        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.numberOfLines = 0

        qrImageView.contentMode = .scaleAspectFit
        qrImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        statusLabel.font = .systemFont(ofSize: 16, weight: .bold)

        let inner = UIStackView(arrangedSubviews: [
            brand, heading, nameLabel,
            row("Host", hostValue), row("Department", departmentValue),
            row("Purpose", purposeValue), row("Visit Date", dateValue),
            row("Pass ID", passIDValue), qrImageView, statusLabel
        ])
        inner.axis = .vertical
        inner.alignment = .center
        inner.spacing = 14
        inner.setCustomSpacing(4, after: brand)
        card.styleAsCard()
        card.addSubview(inner)
        inner.pin(to: card, insets: UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20))
        outer.addArrangedSubview(card)

        emptyLabel.text = "No pass selected.\nRegister a visitor or pick one from the Visitors tab."
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    private func refresh() {
        let store = VisitorStore.shared
        guard let id = store.currentPassID, let v = store.visitor(withPassID: id) else {
            card.isHidden = true
            emptyLabel.isHidden = false
            return
        }
        card.isHidden = false
        emptyLabel.isHidden = true
        nameLabel.text = v.name
        hostValue.text = v.host
        departmentValue.text = v.department
        purposeValue.text = v.purpose
        dateValue.text = v.visitDate.displayString
        passIDValue.text = v.passID
        qrImageView.image = QRCodeService.generate(from: v.passID)
        statusLabel.text = "● \(v.status.rawValue)"
        statusLabel.textColor = v.status.color
    }

    private func row(_ title: String, _ value: UILabel) -> UIView {
        let t = UILabel()
        t.text = title
        t.font = .systemFont(ofSize: 12)
        t.textColor = .secondaryLabel
        t.textAlignment = .center
        value.font = .systemFont(ofSize: 17, weight: .semibold)
        value.textAlignment = .center
        let s = UIStackView(arrangedSubviews: [t, value])
        s.axis = .vertical
        s.spacing = 2
        return s
    }
}
