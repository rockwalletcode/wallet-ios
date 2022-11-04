//
//  ItemSelectionPresenter.swift
//  breadwallet
//
//  Created by Rok on 31/05/2022.
//
//

import UIKit

final class ItemSelectionPresenter: NSObject, Presenter, ItemSelectionActionResponses {
    typealias Models = ItemSelectionModels

    weak var viewController: ItemSelectionViewController?

    // MARK: - ItemSelectionActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item,
              let items = item.items,
              let isAddingEnabled = item.isAddingEnabled
        else { return }
        
        var sections = [Models.Sections.items]
        if isAddingEnabled {
            sections.insert(Models.Sections.addItem, at: 0)
        }
        
        let sectionRows: [Models.Sections: [Any]] = [
            Models.Sections.items: items,
            Models.Sections.addItem: [L10n.Swap.addItem]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentActionSheetRemovePayment(actionResponse: ItemSelectionModels.ActionSheet.ActionResponse) {
        viewController?.displayActionSheetRemovePayment(responseDisplay: .init(instrumentId: actionResponse.instrumentId,
                                                                               last4: actionResponse.last4,
                                                                               actionSheetOkButton: L10n.Buy.removePaymentMethod,
                                                                               actionSheetCancelButton: L10n.Button.cancel))
    }
    
    func presentRemovePaymentPopup(actionResponse: ItemSelectionModels.RemovePaymenetPopup.ActionResponse) {
        let popupViewModel = PopupViewModel(title: .text("\(L10n.Buy.removeCard) \(actionResponse.last4)?"),
                                            buttons: [.init(title: L10n.Staking.remove.uppercased()),
                                                      .init(title: L10n.Button.cancel.uppercased())],
                                            closeButton: .init(image: "close"))
        
        viewController?.displayRemovePaymentPopup(responseDisplay: .init(popupViewModel: popupViewModel,
                                                                    popupConfig: Presets.Popup.normal))
    }
    
    func presentRemovePaymentMessage(actionResponse: ItemSelectionModels.RemovePayment.ActionResponse) {
        let model = InfoViewModel(description: .text(L10n.Buy.cardRemoved), dismissType: .auto)
        let config = Presets.InfoView.verification
        
        viewController?.displayMessage(responseDisplay: .init(model: model,
                                                              config: config))
        
        viewController?.displayRemovePaymentSuccess(responseDisplay: .init())
    }
    
    // MARK: - Additional Helpers

}
