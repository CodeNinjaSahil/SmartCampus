import UIKit

final class RegisterVisitorViewController: UIViewController {
    private let nameField = UITextField.styled(placeholder: "Full Name")
    private let phoneField = UITextField.styled(placeholder: "Phone")
    private let hostField = UITextField.styled(placeholder: "Host")
    private let departmentField = UITextField.styled(placeholder: "Department")
    private let purposeField = UITextField.styled(placeholder: "Purpose")
    private let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register Visitor"
        view.backgroundColor = .systemBackground

        phoneField.keyboardType = .phonePad
        datePicker.datePickerMode = .date
        let dateRow = UIStackView(arrangedSubviews: [datePicker, UIView()])

        let stack = makeScrollingStack(spacing: 14)
        stack.addArrangedSubview(labeled("Full Name", nameField))
        stack.addArrangedSubview(labeled("Phone", phoneField))
        stack.addArrangedSubview(labeled("Host", hostField))
        stack.addArrangedSubview(labeled("Department", departmentField))
        stack.addArrangedSubview(labeled("Purpose", purposeField))
        stack.addArrangedSubview(labeled("Visit Date", dateRow))

        let button = UIButton.primary("GENERATE PASS")
        button.addTarget(self, action: #selector(generateTapped), for: .touchUpInside)
        stack.addArrangedSubview(button)
        stack.setCustomSpacing(24, after: stack.arrangedSubviews[stack.arrangedSubviews.count - 2])

        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }

    private func labeled(_ text: String, _ control: UIView) -> UIStackView {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        let s = UIStackView(arrangedSubviews: [label, control])
        s.axis = .vertical
        s.spacing = 6
        return s
    }

    @objc private func generateTapped() {
        view.endEditing(true)
        let name = (nameField.text ?? "").trimmed
        let phone = (phoneField.text ?? "").trimmed
        let host = (hostField.text ?? "").trimmed

        if name.isEmpty { return showAlert(title: "Missing Name", message: "Please enter the visitor's full name.") }
        if phone.isEmpty { return showAlert(title: "Missing Phone", message: "Please enter a phone number.") }
        if host.isEmpty { return showAlert(title: "Missing Host", message: "Please enter who the visitor is meeting.") }

        let department = (departmentField.text ?? "").trimmed
        let purpose = (purposeField.text ?? "").trimmed

        VisitorStore.shared.register(
            name: name, phone: phone, host: host,
            department: department.isEmpty ? "General" : department,
            purpose: purpose.isEmpty ? "Visit" : purpose,
            visitDate: datePicker.date)

        navigationController?.popViewController(animated: false)
        tabBarController?.selectedIndex = 3   // show the new pass
    }
}
