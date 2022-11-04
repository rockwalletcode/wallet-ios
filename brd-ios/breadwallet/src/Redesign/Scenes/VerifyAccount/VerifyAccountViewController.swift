//
// Created by Equaleyes Solutions Ltd
//

import UIKit

class VerifyAccountViewController: BaseTableViewController<KYCCoordinator,
                                   VerifyAccountInteractor,
                                   VerifyAccountPresenter,
                                   VerifyAccountStore>,
                                   VerifyAccountResponseDisplays {
    
    typealias Models = VerifyAccountModels
    
    override var isModalDismissableEnabled: Bool { return false }
    
    lazy var verifyButton: WrapperView<FEButton> = {
        let button = WrapperView<FEButton>()
        return button
    }()
    
    lazy var laterButton: WrapperView<FEButton> = {
        let button = WrapperView<FEButton>()
        return button
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        // TODO: Cleanup bottom buttons on all screens.
        
        view.addSubview(verifyButton)
        view.addSubview(laterButton)
        
        verifyButton.snp.makeConstraints { make in
            make.centerX.leading.equalToSuperview()
            make.bottom.equalTo(laterButton.snp.top)
        }
        
        verifyButton.wrappedView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.Common.largeButton.rawValue)
            make.edges.equalTo(verifyButton.snp.margins)
        }
        
        verifyButton.setupCustomMargins(top: .small, leading: .large, bottom: .large, trailing: .large)
        
        verifyButton.wrappedView.configure(with: Presets.Button.primary)
        verifyButton.wrappedView.setup(with: .init(title: L10n.Button.verify))
        
        verifyButton.wrappedView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        laterButton.snp.makeConstraints { make in
            make.centerX.leading.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        laterButton.wrappedView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.medium.rawValue)
            make.edges.equalTo(laterButton.snp.margins)
        }
        
        laterButton.setupCustomMargins(top: .small, leading: .large, bottom: .small, trailing: .large)
        
        laterButton.wrappedView.configure(with: Presets.Button.noBorders)
        laterButton.wrappedView.setup(with: .init(title: L10n.Button.maybeLater, isUnderlined: true))
        
        laterButton.wrappedView.addTarget(self, action: #selector(laterTapped), for: .touchUpInside)
    }
    
    // MARK: - Overrides
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Section {
        case .image:
            cell = self.tableView(tableView, coverCellForRowAt: indexPath)
            cell.contentView.setupCustomMargins(vertical: .extraExtraHuge, horizontal: .large)
            
        case .title:
            cell = self.tableView(tableView, titleLabelCellForRowAt: indexPath)
            (cell as? WrapperTableViewCell<FELabel>)?.wrappedView.configure(with: .init(font: Fonts.Title.six, textColor: LightColors.Text.three, textAlignment: .center))
            cell.contentView.setupCustomMargins(vertical: .large, horizontal: .extraExtraHuge)
            
        case .description:
            cell = self.tableView(tableView, descriptionLabelCellForRowAt: indexPath)
            (cell as? WrapperTableViewCell<FELabel>)?.wrappedView.configure(with: .init(font: Fonts.Body.two, textColor: LightColors.Text.two, textAlignment: .center))
            cell.contentView.setupCustomMargins(vertical: .large, horizontal: .extraExtraHuge)
            
        default:
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        cell.setupCustomMargins(vertical: .huge, horizontal: .large)
        
        return cell
    }

    // MARK: - User Interaction
    
    override func buttonTapped() {
        super.buttonTapped()
        
        coordinator?.showVerifications()
    }

    @objc func laterTapped() {
        coordinator?.goBack(completion: {})
    }
    
    // MARK: - VerifyAccountResponseDisplay

    // MARK: - Additional Helpers
}
