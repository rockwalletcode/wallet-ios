//
//  KYCBasicInteractor.swift
//  breadwallet
//
//  Created by Rok on 30/05/2022.
//
//

import UIKit

class KYCBasicInteractor: NSObject, Interactor, KYCBasicViewActions {
    typealias Models = KYCBasicModels
    
    var presenter: KYCBasicPresenter?
    var dataStore: KYCBasicStore?
    
    // MARK: - KYCBasicViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        ProfileWorker().execute { [weak self] result in
            switch result {
            case .success(let profileData):
                CountriesWorker().execute(requestData: CountriesRequestData()) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.dataStore?.firstName = profileData?.firstName
                        self?.dataStore?.lastName = profileData?.lastName
                        self?.dataStore?.country = profileData?.country
                        self?.dataStore?.countryFullName = data?.first(where: { $0.code == self?.dataStore?.country })?.name
                        if let state = profileData?.state {
                            self?.dataStore?.state = state
                            self?.dataStore?.stateName = data?.first(where: { $0.code == self?.dataStore?.country })?.states?.first(where: { $0.iso2 == state })?.name
                        }
                        
                        self?.dataStore?.birthdate = self?.getBirthDateFormatter().date(from: profileData?.dateOfBirth ?? "")
                        if let birthDate = self?.dataStore?.birthdate {
                            self?.dataStore?.birthDateString = self?.getBirthDateFormatter().string(from: birthDate)
                        }
                        
                        self?.presenter?.presentData(actionResponse: .init(item: self?.dataStore))
                        self?.validate(viewAction: .init())
                        
                    case .failure(let error):
                        self?.presenter?.presentData(actionResponse: .init(item: self?.dataStore))
                        self?.presenter?.presentError(actionResponse: .init(error: error))
                    }
                }
                
            case .failure(let error):
                self?.presenter?.presentData(actionResponse: .init(item: self?.dataStore))
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
        
        let data = CountriesRequestData()
        CountriesWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.countries = data
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func nameSet(viewAction: KYCBasicModels.Name.ViewAction) {
        dataStore?.firstName = viewAction.first
        dataStore?.lastName = viewAction.last
        
        validate(viewAction: .init())
    }
    
    func pickCountry(viewAction: KYCBasicModels.SelectCountry.ViewAction) {
        guard viewAction.code == nil else {
            dataStore?.country = viewAction.code
            dataStore?.countryFullName = viewAction.countryFullName
            presenter?.presentData(actionResponse: .init(item: dataStore))
            validate(viewAction: .init())
            return
        }
        
        presenter?.presentCountry(actionResponse: .init(countries: dataStore?.countries))
    }
    
    func pickState(viewAction: KYCBasicModels.SelectState.ViewAction) {
        guard viewAction.state == nil,
              let countryCode = dataStore?.country,
              let states = dataStore?.countries?.first(where: { $0.code == countryCode })?.states
        else {
            dataStore?.state = viewAction.state?.iso2
            dataStore?.stateName = viewAction.state?.name
            presenter?.presentData(actionResponse: .init(item: dataStore))
            validate(viewAction: .init())
            return
        }
        
        presenter?.presentState(actionResponse: .init(states: states))
    }
    
    func birthDateSet(viewAction: KYCBasicModels.BirthDate.ViewAction) {
        if let date = viewAction.date {
            dataStore?.birthdate = date
            dataStore?.birthDateString = getBirthDateFormatter().string(from: dataStore?.birthdate ?? Date())
        }
        
        presenter?.presentData(actionResponse: .init(item: dataStore))
        validate(viewAction: .init())
    }
    
    func validate(viewAction: KYCBasicModels.Validate.ViewAction) {
        var isValid = FieldValidator.validate(fields: [dataStore?.firstName,
                                                       dataStore?.lastName,
                                                       dataStore?.country,
                                                       dataStore?.birthDateString])
        if dataStore?.country == "US" {
            // only US customers need to fill out the state field
            isValid = isValid && FieldValidator.validate(fields: [dataStore?.state])
        }
        
        presenter?.presentValidate(actionResponse: .init(isValid: isValid))
    }
    
    func submit(viewAction: KYCBasicModels.Submit.ViewAction) {
        guard let firstName = dataStore?.firstName,
              let lastName = dataStore?.lastName,
              let country = dataStore?.country,
              let state = dataStore?.state,
              let birthDateText = dataStore?.birthDateString,
              let birthDate = dataStore?.birthdate else {
            return
        }
        
        guard let legalDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()),
              birthDate <= legalDate else {
                  presenter?.presentNotification(actionResponse: .init(body: L10n.Account.verification))
            return
        }
        
        let data = KYCBasicRequestData(firstName: firstName,
                                       lastName: lastName,
                                       country: country,
                                       state: state,
                                       birthDate: birthDateText)
        KYCLevelOneWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.presentSubmit(actionResponse: .init())
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    // MARK: - Aditional helpers
    
    func getBirthDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
}
