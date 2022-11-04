//
//  KYCDocumentPickerViewController.swift
//  breadwallet
//
//  Created by Rok on 07/06/2022.
//
//

import AVFoundation
import UIKit

class KYCDocumentPickerViewController: BaseTableViewController<KYCCoordinator,
                                       KYCDocumentPickerInteractor,
                                       KYCDocumentPickerPresenter,
                                       KYCDocumentPickerStore>,
                                       KYCDocumentPickerResponseDisplays {
    
    typealias Models = KYCDocumentPickerModels
    
    override var sceneLeftAlignedTitle: String? {
        return L10n.Account.proofOfIdentity
    }
    
    var confirmPhoto: (() -> Void)?
    
    // MARK: - Overrides
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Sections {
        case .title:
            cell = self.tableView(tableView, labelCellForRowAt: indexPath)
            cell.setupCustomMargins(vertical: .large, horizontal: .large)
            (cell as? WrapperTableViewCell<FELabel>)?.wrappedView.configure(with: .init(font: Fonts.Title.six, textColor: LightColors.Text.three))
            
        case .documents:
            cell = self.tableView(tableView, navigationCellForRowAt: indexPath)
            (cell as? WrapperTableViewCell<NavigationItemView>)?.setup({ view in
                view.configure(with: .init(image: Presets.Image.primary,
                                           label: .init(font: Fonts.Body.one,
                                                        textColor: LightColors.Contrast.one),
                                           background: .init(backgroundColor: LightColors.Background.cards)))
                
                view.snp.makeConstraints { make in
                    make.height.equalTo(ViewSizes.extralarge.rawValue)
                }
            })
            
            cell.setupCustomMargins(vertical: .extraLarge, horizontal: .large)
            (cell as? WrapperTableViewCell<NavigationItemView>)?.wrappedView.setupCustomMargins(vertical: .zero, horizontal: .large)
            (cell as? WrapperTableViewCell<NavigationItemView>)?.wrappedView.setBackground(with: .init(backgroundColor: LightColors.Background.cards,
                                           tintColor: LightColors.Text.one,
                                           border: Presets.Border.zero))
            (cell as? WrapperTableViewCell<NavigationItemView>)?.wrappedView.layer.setShadow(with: Presets.Shadow.light)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] as? Models.Sections {
        case .documents:
            interactor?.selectDocument(viewAction: .init(index: indexPath.row))
            
        default: return
        }
    }

    // MARK: - User Interaction

    // MARK: - KYCDocumentPickerResponseDisplay
    
    func displayTakePhoto(responseDisplay: KYCDocumentPickerModels.Photo.ResponseDisplay) {
        LoadingView.hide()
        
        coordinator?.showImagePicker(model: responseDisplay.model,
                                     device: responseDisplay.device) { [weak self] image in
            guard let image = image else { return }
            self?.coordinator?.showDocumentReview(checklist: responseDisplay.checklist, image: image)
        }
    }
    
    func displayFinish(responseDisplay: KYCDocumentPickerModels.Finish.ResponseDisplay) {
        LoadingView.hide()
        
        coordinator?.showKYCFinal()
    }
    
    // MARK: - Additional Helpers
}

protocol ImagePickable: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker(model: KYCCameraImagePickerModel?,
                         device: AVCaptureDevice,
                         completion: ((UIImage?) -> Void)?)
}
