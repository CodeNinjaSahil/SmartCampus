import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = Theme.accent

        viewControllers = [
            wrap(DashboardViewController(), title: "Home", symbol: "house.fill"),
            wrap(VisitorsViewController(), title: "Visitors", symbol: "person.2.fill"),
            wrap(ScanViewController(), title: "Scan", symbol: "camera.viewfinder"),
            wrap(PassViewController(), title: "Pass", symbol: "qrcode"),
            wrap(ProfileViewController(), title: "Profile", symbol: "person.crop.circle.fill")
        ]
    }

    private func wrap(_ vc: UIViewController, title: String, symbol: String) -> UINavigationController {
        vc.title = title
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: symbol), selectedImage: nil)
        return nav
    }
}
