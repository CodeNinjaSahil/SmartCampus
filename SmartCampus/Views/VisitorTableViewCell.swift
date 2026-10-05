import UIKit

final class VisitorTableViewCell: UITableViewCell {
    static let reuseID = "VisitorCell"

    private let nameLabel = UILabel()
    private let detailLabel = UILabel()
    private let statusLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator

        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        detailLabel.font = .systemFont(ofSize: 14)
        detailLabel.textColor = .secondaryLabel
        statusLabel.font = .systemFont(ofSize: 12, weight: .bold)

        let stack = UIStackView(arrangedSubviews: [nameLabel, detailLabel, statusLabel])
        stack.axis = .vertical
        stack.spacing = 4
        contentView.addSubview(stack)
        stack.pin(to: contentView, insets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 8))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with v: Visitor) {
        nameLabel.text = v.name
        detailLabel.text = "\(v.passID) • \(v.department) • \(v.purpose)"
        statusLabel.text = "● \(v.status.rawValue)"
        statusLabel.textColor = v.status.color
    }
}
