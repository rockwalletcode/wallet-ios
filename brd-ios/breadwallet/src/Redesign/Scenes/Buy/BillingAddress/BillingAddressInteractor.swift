//
//  BillingAddressInteractor.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 01/08/2022.
//  Copyright © 2022 RockWallet, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import Checkout
import Frames

class BillingAddressInteractor: NSObject, Interactor, BillingAddressViewActions {
    typealias Models = BillingAddressModels

    var presenter: BillingAddressPresenter?
    var dataStore: BillingAddressStore?

    // MARK: - BillingAddressViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard let reference = dataStore?.paymentReference else {
            presenter?.presentData(actionResponse: .init(item: dataStore))
            return
        }
        
        let requestData = PaymentStatusRequestData(reference: reference)
        PaymentStatusWorker().execute(requestData: requestData) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.paymentstatus = data?.status
                
                guard self?.dataStore?.paymentstatus?.isSuccesful == true else {
                    self?.presenter?.presentError(actionResponse: .init(error: GeneralError(errorMessage: L10n.Buy.paymentFailed)))
                    return
                }
                self?.presenter?.presentSubmit(actionResponse: .init())
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func getPaymentCards(viewAction: BillingAddressModels.PaymentCards.ViewAction) {
        PaymentCardsWorker().execute(requestData: PaymentCardsRequestData()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.presenter?.presentPaymentCards(actionResponse: .init(allPaymentCards: data))
                
            case .failure(let error):
                self.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func stateProvinceSet(viewAction: BillingAddressModels.StateProvince.ViewAction) {
        dataStore?.stateProvince = viewAction.stateProvince
        
        validate(viewAction: .init())
    }
    
    func addressSet(viewAction: BillingAddressModels.Address.ViewAction) {
        dataStore?.address = viewAction.address
        
        validate(viewAction: .init())
    }
    
    func nameSet(viewAction: BillingAddressModels.Name.ViewAction) {
        dataStore?.firstName = viewAction.first
        dataStore?.lastName = viewAction.last
        
        validate(viewAction: .init())
    }
    
    func cityAndZipPostalSet(viewAction: BillingAddressModels.CityAndZipPostal.ViewAction) {
        dataStore?.city = viewAction.city
        dataStore?.zipPostal = viewAction.zipPostal
        
        validate(viewAction: .init())
    }
    
    func pickCountry(viewAction: BillingAddressModels.SelectCountry.ViewAction) {
        guard viewAction.code == nil else {
            dataStore?.country = viewAction.code
            dataStore?.countryFullName = viewAction.countryFullName
            presenter?.presentData(actionResponse: .init(item: dataStore))
            validate(viewAction: .init())
            
            return
        }
        
        let data = CountriesRequestData()
        CountriesWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let data):
                self?.presenter?.presentCountry(actionResponse: .init(countries: data))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func validate(viewAction: BillingAddressModels.Validate.ViewAction) {
        presenter?.presentValidate(actionResponse: .init(isValid: dataStore?.isValid ?? false))
    }
    
    func submit(viewAction: BillingAddressModels.Submit.ViewAction) {
        guard let countryIso = dataStore?.country,
              let street = dataStore?.address,
              let city = dataStore?.city,
              let state = dataStore?.stateProvince,
              let zip = dataStore?.zipPostal,
              let lastName = dataStore?.lastName,
              let firstName = dataStore?.firstName,
              let cardNumber = dataStore?.cardNumber,
              let month = Int(dataStore?.expMonth ?? ""),
              let year = Int(dataStore?.expYear ?? ""),
              let cvv = dataStore?.cvv
              
        else { return }
        
        let country = Checkout.Country(iso3166Alpha2: countryIso)
        let address = Address(addressLine1: street,
                              addressLine2: nil,
                              city: city,
                              state: state,
                              zip: zip,
                              country: country)
        
        let expiration = ExpiryDate(month: month, year: year)
        let card = Checkout.Card(number: cardNumber,
                                 expiryDate: expiration,
                                 name: firstName + " " + lastName,
                                 cvv: cvv,
                                 billingAddress: address,
                                 phone: nil)
        
        let checkoutApiService = CheckoutAPIService(publicKey: E.checkoutApiToken, environment: E.isSandbox ? .sandbox : .live)
        checkoutApiService.createToken(.card(card)) { [weak self] result in
            switch result {
            case .success(let token):
                self?.afterSubmit(token: token.token)
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    private func afterSubmit(token: String?) {
        guard let dataStore = dataStore, let checkoutToken = token else { return }
        
        let data = AddCardRequestData(token: checkoutToken,
                                      firstName: dataStore.firstName,
                                      lastName: dataStore.lastName,
                                      countryCode: dataStore.country,
                                      state: dataStore.stateProvince,
                                      city: dataStore.city,
                                      zip: dataStore.zipPostal,
                                      address: dataStore.address)
        
        AddCardWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let exchangeData):
                self?.dataStore?.paymentReference = exchangeData?.paymentReference
                guard let redirectUrlString = exchangeData?.redirectUrl, let
                        redirectUrl = URL(string: redirectUrlString) else {
                    self?.getData(viewAction: .init())
                    return
                }
                
                ExchangeManager.shared.reload()
                self?.presenter?.presentThreeDSecure(actionResponse: .init(url: redirectUrl))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
        
    }
    
    // MARK: - Aditional helpers
}
