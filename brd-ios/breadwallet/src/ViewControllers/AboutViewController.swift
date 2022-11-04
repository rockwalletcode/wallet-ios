// 
// Created by Equaleyes Solutions Ltd
//

import UIKit

class AboutViewController: UIViewController {
    private lazy var aboutHeaderView: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo_vertical")
        
        return logo
    }()
    
    private lazy var aboutFooterView: UILabel = {
        let aboutFooterView = UILabel.wrapping(font: Fonts.Body.two, color: LightColors.Text.two)
        aboutFooterView.translatesAutoresizingMaskIntoConstraints = false
        
        let aboutFooterStyle = NSMutableParagraphStyle()
        aboutFooterStyle.lineSpacing = 5.0
        aboutFooterStyle.alignment = .center
        let attributes = [NSAttributedString.Key.paragraphStyle: aboutFooterStyle]
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            aboutFooterView.attributedText = NSAttributedString(string: L10n.About.footer(version, build), attributes: attributes)
        }
        
        return aboutFooterView
    }()
    
    private lazy var termsAndPrivacyStack: UIStackView = {
        let view = UIStackView()
        view.spacing = Margins.large.rawValue
        return view
    }()
    
    private lazy var privacy: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.underlineStyle: 1,
        NSAttributedString.Key.font: Fonts.Subtitle.two,
        NSAttributedString.Key.foregroundColor: LightColors.secondary]
        
        let attributedString = NSMutableAttributedString(string: L10n.About.privacy, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }()
    
    private lazy var terms: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.underlineStyle: 1,
        NSAttributedString.Key.font: Fonts.Subtitle.two,
        NSAttributedString.Key.foregroundColor: LightColors.secondary]
        
        let attributedString = NSMutableAttributedString(string: L10n.About.terms, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = L10n.About.title
        
        addSubviews()
        addConstraints()
        setActions()
        
        view.backgroundColor = LightColors.Background.one
    }

    private func addSubviews() {
        view.addSubview(aboutHeaderView)
        view.addSubview(termsAndPrivacyStack)
        termsAndPrivacyStack.addArrangedSubview(terms)
        termsAndPrivacyStack.addArrangedSubview(privacy)
        view.addSubview(aboutFooterView)
    }

    private func addConstraints() {
        aboutHeaderView.constrain([
            aboutHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewSizes.extraExtraHuge.rawValue),
            aboutHeaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aboutHeaderView.widthAnchor.constraint(equalToConstant: 213)])
        termsAndPrivacyStack.constrain([
            termsAndPrivacyStack.topAnchor.constraint(equalTo: aboutHeaderView.bottomAnchor, constant: Margins.extraLarge.rawValue * 2),
            termsAndPrivacyStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        aboutFooterView.constrain([
            aboutFooterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.huge.rawValue),
            aboutFooterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.huge.rawValue),
            aboutFooterView.topAnchor.constraint(equalTo: privacy.bottomAnchor, constant: Margins.extraLarge.rawValue * 2)])
    }
    
    private func setActions() {
        privacy.tap = { [weak self] in
            self?.presentURL(string: C.privacyPolicy, title: self?.privacy.titleLabel?.text ?? "")
        }
        
        terms.tap = { [weak self] in
            self?.presentURL(string: C.termsAndConditions, title: self?.terms.titleLabel?.text ?? "")
        }
    }

    private func presentURL(string: String, title: String) {
        guard let url = URL(string: string) else { return }
        let webViewController = SimpleWebViewController(url: url)
        webViewController.setup(with: .init(title: title))
        let navController = RootNavigationController(rootViewController: webViewController)
        webViewController.setAsNonDismissableModal()
        
        navigationController?.present(navController, animated: true)
    }
}
