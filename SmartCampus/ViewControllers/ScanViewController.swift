import UIKit
import AVFoundation

final class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    private let session = AVCaptureSession()
    private let cameraView = UIView()
    private let hintLabel = UILabel()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var isConfigured = false
    private var handled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Manual", style: .plain, target: self, action: #selector(manualEntry))

        let heading = UILabel()
        heading.text = "VERIFY VISITOR PASS"
        heading.font = .systemFont(ofSize: 20, weight: .bold)
        heading.textAlignment = .center

        cameraView.backgroundColor = .black
        cameraView.layer.cornerRadius = 20
        cameraView.layer.masksToBounds = true
        cameraView.layer.borderColor = Theme.accent.cgColor
        cameraView.layer.borderWidth = 3

        hintLabel.text = "Point the camera at the QR code"
        hintLabel.textColor = .secondaryLabel
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 0

        [heading, cameraView, hintLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            heading.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            heading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            heading.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            cameraView.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 28),
            cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraView.widthAnchor.constraint(equalToConstant: 300),
            cameraView.heightAnchor.constraint(equalToConstant: 300),

            hintLabel.topAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: 20),
            hintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            hintLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        requestCameraAccess()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handled = false
        startSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { [session] in session.stopRunning() }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = cameraView.bounds
    }

    // MARK: Camera
    private func requestCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    granted ? self.configureSession()
                            : (self.hintLabel.text = "Camera access denied. Enable it in Settings, or use Manual.")
                }
            }
        default:
            hintLabel.text = "Camera access denied. Enable it in Settings, or use Manual."
        }
    }

    private func configureSession() {
        guard !isConfigured else { return }
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            hintLabel.text = "Camera not available (e.g. Simulator). Use Manual to enter a pass ID."
            return
        }
        session.addInput(input)

        let output = AVCaptureMetadataOutput()
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = [.qr]

        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = cameraView.bounds
        cameraView.layer.addSublayer(layer)
        previewLayer = layer
        isConfigured = true
        startSession()
    }

    private func startSession() {
        guard isConfigured, !session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [session] in session.startRunning() }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = object.stringValue else { return }
        handle(code: code)
    }

    // MARK: Verification
    @objc private func manualEntry() {
        let alert = UIAlertController(title: "Enter Pass ID", message: "e.g. VIS-001", preferredStyle: .alert)
        alert.addTextField { $0.autocapitalizationType = .allCharacters }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Verify", style: .default) { [weak self] _ in
            self?.handle(code: alert.textFields?.first?.text ?? "")
        })
        present(alert, animated: true)
    }

    private func handle(code: String) {
        guard !handled else { return }
        handled = true
        let passID = code.trimmed.uppercased()
        if let visitor = VisitorStore.shared.visitor(withPassID: passID) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            showResult(for: visitor)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            showInvalid()
        }
    }

    private func showResult(for v: Visitor) {
        let isActive = v.status == .active
        let alert = UIAlertController(
            title: isActive ? "✓ VALID PASS" : "⚠︎ PASS NOT ACTIVE",
            message: "\(v.name)\n\nHost: \(v.host)\nDepartment: \(v.department)\nStatus: \(v.status.rawValue)",
            preferredStyle: .alert)
        if isActive {
            alert.addAction(UIAlertAction(title: "Allow Entry", style: .default) { [weak self] _ in
                self?.handled = false
            })
            alert.addAction(UIAlertAction(title: "Mark Exited", style: .destructive) { [weak self] _ in
                VisitorStore.shared.updateStatus(passID: v.passID, to: .exited)
                self?.handled = false
            })
        } else {
            alert.addAction(UIAlertAction(title: "Close", style: .cancel) { [weak self] _ in
                self?.handled = false
            })
        }
        present(alert, animated: true)
    }

    private func showInvalid() {
        let alert = UIAlertController(title: "✕ INVALID PASS",
                                      message: "Visitor pass not found.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel) { [weak self] _ in
            self?.handled = false
        })
        present(alert, animated: true)
    }
}
