//
//  DocumentReviewViewController.swift
//  breadwallet
//
//  Created by Rok on 13/06/2022.
//
//

import UIKit

class DocumentReviewViewController: BaseTableViewController<KYCCoordinator,
                                    DocumentReviewInteractor,
                                    DocumentReviewPresenter,
                                    DocumentReviewStore>,
                                    DocumentReviewResponseDisplays {
    
    typealias Models = DocumentReviewModels

    override var sceneLeftAlignedTitle: String? {
        return L10n.Account.submitPhoto
    }
    
    var retakePhoto: (() -> Void)?
    var confirmPhoto: (() -> Void)?
    
    // MARK: - Overrides
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Sections {
        case .title:
            cell =  self.tableView(tableView, labelCellForRowAt: indexPath)
            (cell as? WrapperTableViewCell<FELabel>)?.wrappedView.configure(with: .init(font: Fonts.Title.six, textColor: LightColors.Text.three))
            cell.setupCustomMargins(vertical: .large, horizontal: .large)
            
        case .checkmarks:
            cell = self.tableView(tableView, checkmarkCellForRowAt: indexPath)
            cell.setupCustomMargins(top: .extraExtraHuge, leading: .huge, bottom: .extraExtraHuge, trailing: .large)
            
        case .image:
            cell = self.tableView(tableView, coverCellForRowAt: indexPath)
            cell.setupCustomMargins(vertical: .large, horizontal: .extraExtraHuge)
            
        case .buttons:
            cell = self.tableView(tableView, buttonsCellForRowAt: indexPath)
            cell.setupCustomMargins(vertical: .zero, horizontal: .large)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, buttonsCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, buttonsCellForRowAt: indexPath)
        
        guard let cell = cell as? WrapperTableViewCell<ScrollableButtonsView> else {
            return cell
        }
        
        cell.setup { view in
            view.configure(with: .init(buttons: [Presets.Button.secondary, Presets.Button.primary], isDoubleButtonStack: true))
            
            view.callbacks = [
                retakePhotoTapped,
                confirmPhotoTapped
            ]
        }
        
        return cell
    }

    // MARK: - User Interaction

    private func retakePhotoTapped() {
        retakePhoto?()
    }
    
    private func confirmPhotoTapped() {
        confirmPhoto?()
    }
    
    // MARK: - DocumentReviewResponseDisplay

    // MARK: - Additional Helpers
}
