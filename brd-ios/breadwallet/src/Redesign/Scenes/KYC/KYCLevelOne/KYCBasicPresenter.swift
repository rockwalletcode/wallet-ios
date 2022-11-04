//
//  KYCBasicPresenter.swift
//  breadwallet
//
//  Created by Rok on 30/05/2022.
//
//

import UIKit

final class KYCBasicPresenter: NSObject, Presenter, KYCBasicActionResponses {
    typealias Models = KYCBasicModels

    weak var viewController: KYCBasicViewController?

    // MARK: - KYCBasicActionResponses

    // MARK: - Additional Helpers
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item else { return }
        let sections: [Models.Section] = [
            .name,
            .country,
            .birthdate,
            .confirm
        ]
        
        let dateViewModel: DateViewModel
        let title: LabelViewModel? = .text(L10n.Account.dateOfBirth)
        
        if let date = item.birthdate {
            let components = Calendar.current.dateComponents([.day, .year, .month], from: date)
            let dateFormat = "%02d"
            guard let month = components.month,
                  let day = components.day,
                  let year = components.year else { return }
            
            dateViewModel = DateViewModel(date: date,
                                          title: title,
                                          month: .init(value: String(format: dateFormat, month)),
                                          day: .init(value: String(format: dateFormat, day)),
                                          year: .init(value: "\(year)"))
        } else {
            dateViewModel = DateViewModel(date: nil,
                                          title: title,
                                          month: .init(title: "MM"),
                                          day: .init(title: "DD"),
                                          year: .init(title: "YYYY"))
        }
        
        let sectionRows: [Models.Section: [Any]] = [
            .name: [
                DoubleHorizontalTextboxViewModel(primaryTitle: .text(L10n.Account.writeYourName),
                                                 primary: .init(title: L10n.Buy.firstName, value: item.firstName),
                                                 secondary: .init(title: L10n.Buy.lastName, value: item.lastName))
            ],
            .country: [
                TextFieldModel(title: L10n.Account.country,
                               value: item.countryFullName,
                               trailing: .imageName("chevron-down"))
            ],
            .birthdate: [
                dateViewModel
            ],
            .confirm: [
                ButtonViewModel(title: L10n.Button.confirm.uppercased())
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentCountry(actionResponse: KYCBasicModels.SelectCountry.ActionResponse) {
        guard let countries = actionResponse.countries else { return }
        viewController?.displayCountry(responseDisplay: .init(countries: countries))
    }
    
    func presentValidate(actionResponse: KYCBasicModels.Validate.ActionResponse) {
        viewController?.displayValidate(responseDisplay: .init(isValid: actionResponse.isValid))
    }
    
    func presentSubmit(actionResponse: KYCBasicModels.Submit.ActionResponse) {
        viewController?.displaySubmit(responseDisplay: .init())
    }
}
