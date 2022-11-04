//
//  AddCardInteractor.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 03/08/2022.
//  Copyright © 2022 Placeholder, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Frames
import UIKit

class AddCardInteractor: NSObject, Interactor, AddCardViewActions {
    typealias Models = AddCardModels

    var presenter: AddCardPresenter?
    var dataStore: AddCardStore?

    // MARK: - AddCardViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        let months: [String] = (1...12).compactMap { String($0) }
        let year = Calendar.current.component(.year, from: Date())
        let years: [String] = (year...year + 100).compactMap { String($0) }
        
        dataStore?.months = months
        dataStore?.years = years
        
        presenter?.presentData(actionResponse: .init(item: dataStore))
    }
    
    func cardInfoSet(viewAction: AddCardModels.CardInfo.ViewAction) {
        if let index = viewAction.expirationDateIndex {
            var month = dataStore?.months[index.primaryRow] ?? ""
            month = month.count == 1 ? "0\(month)" : month
            let year = dataStore?.years[index.secondaryRow] ?? ""
            dataStore?.cardExpDateString = "\(month)/\(year.dropFirst(2))"
            
            let date = dataStore?.cardExpDateString?.components(separatedBy: "/")
            dataStore?.cardExpDateMonth = date?.first
            dataStore?.cardExpDateYear = date?.last
        }
        
        if let number = viewAction.number {
            dataStore?.cardNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        }
        
        if let cvv = viewAction.cvv {
            dataStore?.cardCVV = cvv
        }
        
        presenter?.presentCardInfo(actionResponse: .init(dataStore: dataStore))
        
        validate(viewAction: .init())
    }
    
    func validate(viewAction: AddCardModels.Validate.ViewAction) {
        let isValid = FieldValidator.validate(fields: [dataStore?.cardExpDateString])
        && FieldValidator.validate(cvv: dataStore?.cardCVV)
        && FieldValidator.validate(cardNumber: dataStore?.cardNumber)
        
        presenter?.presentValidate(actionResponse: .init(isValid: isValid))
    }
    
    func submit(viewAction: AddCardModels.Submit.ViewAction) {
        guard let number = dataStore?.cardNumber,
              let cvv = dataStore?.cardCVV,
              let month = dataStore?.cardExpDateMonth,
              let year = dataStore?.cardExpDateYear else { return }
        
        let checkoutAPIClient = CheckoutAPIClient(publicKey: E.checkoutApiToken,
                                                  environment: E.isSandbox ? .sandbox : .live)
        
        let cardTokenRequest = CkoCardTokenRequest(number: number,
                                                   expiryMonth: month,
                                                   expiryYear: year,
                                                   cvv: cvv)
        
        checkoutAPIClient.createCardToken(card: cardTokenRequest) { [weak self] result in
            switch result {
            case .success(let response):
                self?.presenter?.presentSubmit(actionResponse: .init(checkoutToken: response))
                
            case .failure:
                self?.presenter?.presentError(actionResponse: .init(error: BuyErrors.authorizationFailed))
            }
        }
    }
    
    func showCvvInfoPopup(viewAction: AddCardModels.CvvInfoPopup.ViewAction) {
        presenter?.presentCvvInfoPopup(actionResponse: .init())
    }
}
