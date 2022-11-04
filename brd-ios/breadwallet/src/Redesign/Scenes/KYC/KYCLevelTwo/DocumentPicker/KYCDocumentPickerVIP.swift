//
//  KYCDocumentPickerVIP.swift
//  breadwallet
//
//  Created by Rok on 07/06/2022.
//
//

import UIKit

extension Scenes {
    static let KYCDocumentPicker = KYCDocumentPickerViewController.self
}

protocol KYCDocumentPickerViewActions: BaseViewActions, FetchViewActions {
    func selectDocument(viewAction: KYCDocumentPickerModels.Documents.ViewAction)
    func takePhoto(viewAction: KYCDocumentPickerModels.Photo.ViewAction)
    func confirmPhoto(viewAction: KYCDocumentPickerModels.ConfirmPhoto.ViewAction)
    func finish(viewAction: KYCDocumentPickerModels.Finish.ViewAction)
}

protocol KYCDocumentPickerActionResponses: BaseActionResponses, FetchActionResponses {
    func presentTakePhoto(actionResponse: KYCDocumentPickerModels.Photo.ActionResponse)
    func presentFinish(actionResponse: KYCDocumentPickerModels.Finish.ActionResponse)
}

protocol KYCDocumentPickerResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayTakePhoto(responseDisplay: KYCDocumentPickerModels.Photo.ResponseDisplay)
    func displayFinish(responseDisplay: KYCDocumentPickerModels.Finish.ResponseDisplay)
}

protocol KYCDocumentPickerDataStore: BaseDataStore, FetchDataStore {
    var documents: [Document]? { get set }
    var front: UIImage? { get set }
    var back: UIImage? { get set }
    var selfie: UIImage? { get set }
}

protocol KYCDocumentPickerDataPassing {
    var dataStore: KYCDocumentPickerDataStore? { get }
}

protocol KYCDocumentPickerRoutes: CoordinatableRoutes {
    func showDocumentVerification(for document: Document)
}
