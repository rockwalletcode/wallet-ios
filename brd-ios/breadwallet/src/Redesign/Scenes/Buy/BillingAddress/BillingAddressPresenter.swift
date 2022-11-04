//
//  BillingAddressPresenter.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 01/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

final class BillingAddressPresenter: NSObject, Presenter, BillingAddressActionResponses {
    typealias Models = BillingAddressModels

    weak var viewController: BillingAddressViewController?

    // MARK: - BillingAddressActionResponses

    // MARK: - Additional Helpers
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item else { return }
        let sections: [Models.Section] = [
            .name,
            .country,
            .stateProvince,
            .cityAndZipPostal,
            .address,
            .confirm
        ]
        
        let sectionRows: [Models.Section: [Any]] = [
            .name: [
                DoubleHorizontalTextboxViewModel(primary: .init(title: L10n.Buy.firstName,
                                                                value: item.firstName),
                                                 secondary: .init(title: L10n.Buy.lastName,
                                                                  value: item.lastName))
            ],
            .country: [
                TextFieldModel(title: L10n.Account.country,
                               value: item.countryFullName,
                               trailing: .imageName("chevron-down"))
            ],
            .stateProvince: [
                TextFieldModel(title: L10n.Buy.stateProvince,
                               value: item.stateProvince)
            ],
            .cityAndZipPostal: [
                DoubleHorizontalTextboxViewModel(primary: .init(title: L10n.Buy.city,
                                                                value: item.city),
                                                 secondary: .init(title: L10n.Buy.zipPostalCode,
                                                                  value: item.zipPostal))
            ],
            .address: [
                TextFieldModel(title: L10n.Buy.address,
                               value: item.address)
            ],
            .confirm: [
                ButtonViewModel(title: L10n.Button.confirm.uppercased())
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentCountry(actionResponse: BillingAddressModels.SelectCountry.ActionResponse) {
        guard let countries = actionResponse.countries else { return }
        viewController?.displayCountry(responseDisplay: .init(countries: countries))
    }
    
    func presentPaymentCards(actionResponse: BillingAddressModels.PaymentCards.ActionResponse) {
        viewController?.displayPaymentCards(responseDisplay: .init(allPaymentCards: actionResponse.allPaymentCards ?? []))
    }
    
    func presentThreeDSecure(actionResponse: BillingAddressModels.ThreeDSecure.ActionResponse) {
        viewController?.displayThreeDSecure(responseDisplay: .init(url: actionResponse.url))
    }
    
    func presentValidate(actionResponse: BillingAddressModels.Validate.ActionResponse) {
        viewController?.displayValidate(responseDisplay: .init(isValid: actionResponse.isValid))
    }
    
    func presentSubmit(actionResponse: BillingAddressModels.Submit.ActionResponse) {
        viewController?.displaySubmit(responseDisplay: .init())
    }
}
