import SafariServices
import SwiftUI

struct InAppVideoBrowser: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false

        let browser = SFSafariViewController(url: url, configuration: configuration)
        browser.preferredBarTintColor = UIColor(AppTheme.backgroundRaised)
        browser.preferredControlTintColor = UIColor(AppTheme.accent)
        browser.dismissButtonStyle = .close
        return browser
    }

    func updateUIViewController(_ browser: SFSafariViewController, context: Context) {}
}
