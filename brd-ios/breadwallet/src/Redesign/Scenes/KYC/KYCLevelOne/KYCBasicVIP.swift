//
//  KYCBasicVIP.swift
//  breadwallet
//
//  Created by Rok on 30/05/2022.
//
//

import UIKit

extension Scenes {
    static let KYCBasic = KYCBasicViewController.self
}

protocol KYCBasicViewActions: BaseViewActions, FetchViewActions {
    func pickCountry(viewAction: KYCBasicModels.SelectCountry.ViewAction)
    func pickState(viewAction: KYCBasicModels.SelectState.ViewAction)
    func birthDateSet(viewAction: KYCBasicModels.BirthDate.ViewAction)
    func nameSet(viewAction: KYCBasicModels.Name.ViewAction)
    func validate(viewAction: KYCBasicModels.Validate.ViewAction)
    func submit(viewAction: KYCBasicModels.Submit.ViewAction)
}

protocol KYCBasicActionResponses: BaseActionResponses, FetchActionResponses {
    func presentCountry(actionResponse: KYCBasicModels.SelectCountry.ActionResponse)
    func presentState(actionResponse: KYCBasicModels.SelectState.ActionResponse)
    func presentValidate(actionResponse: KYCBasicModels.Validate.ActionResponse)
    func presentSubmit(actionResponse: KYCBasicModels.Submit.ActionResponse)
}

protocol KYCBasicResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayCountry(responseDisplay: KYCBasicModels.SelectCountry.ResponseDisplay)
    func displayState(responseDisplay: KYCBasicModels.SelectState.ResponseDisplay)
    func displayValidate(responseDisplay: KYCBasicModels.Validate.ResponseDisplay)
    func displaySubmit(responseDisplay: KYCBasicModels.Submit.ResponseDisplay)
}

protocol KYCBasicDataStore: BaseDataStore, FetchDataStore {
    var firstName: String? { get set }
    var lastName: String? { get set }
    var country: String? { get set }
    var countryFullName: String? { get set }
    var birthdate: Date? { get set }
    var birthDateString: String? { get set }
}

protocol KYCBasicDataPassing {
    var dataStore: KYCBasicDataStore? { get }
}

protocol KYCBasicRoutes: CoordinatableRoutes {
    func showKYCLevelOne()
    func showCountrySelector(countries: [Country], selected: ((Country?) -> Void)?)
    func showStateSelector(states: [USState], selected: ((USState?) -> Void)?)
    func showKYCLevelTwo()
    func showIdentitySelector()
}
