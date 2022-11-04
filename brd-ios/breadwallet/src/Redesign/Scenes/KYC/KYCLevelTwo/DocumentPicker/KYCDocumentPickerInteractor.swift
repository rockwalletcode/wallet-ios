//
//  KYCDocumentPickerInteractor.swift
//  breadwallet
//
//  Created by Rok on 07/06/2022.
//
//

import UIKit

class KYCDocumentPickerInteractor: NSObject, Interactor, KYCDocumentPickerViewActions {
    
    typealias Models = KYCDocumentPickerModels

    var presenter: KYCDocumentPickerPresenter?
    var dataStore: KYCDocumentPickerStore?

    // MARK: - KYCDocumentPickerViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        KYCDocumentWorker().execute { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.documents = data
                self?.presenter?.presentData(actionResponse: .init(item: data))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func selectDocument(viewAction: KYCDocumentPickerModels.Documents.ViewAction) {
        guard let index = viewAction.index,
              index < (dataStore?.documents?.count ?? 0) else {
            return
        }
        dataStore?.document = dataStore?.documents?[index]
        takePhoto(viewAction: .init())
    }
    
    func takePhoto(viewAction: KYCDocumentPickerModels.Photo.ViewAction) {
        if dataStore?.front == nil {
            presenter?.presentTakePhoto(actionResponse: .init(document: dataStore?.document, isFront: true))
        } else if dataStore?.document != .passport,
                  dataStore?.back == nil {
            presenter?.presentTakePhoto(actionResponse: .init(document: dataStore?.document, isBack: true))
        } else if dataStore?.selfie == nil {
            presenter?.presentTakePhoto(actionResponse: .init(document: dataStore?.document, isSelfie: true))
        } else {
            guard let document = dataStore?.document else { return
                
            }
            
            let data = KYCDocumentUploadRequestData(front: dataStore?.front,
                                                    back: dataStore?.back,
                                                    documentyType: document)
            let selfie = dataStore?.selfie
            KYCDocumentUploadWorker().executeMultipartRequest(data: data) { [weak self] result in
                switch result {
                case .success:
                    let data = KYCDocumentUploadRequestData(selfie: selfie, documentyType: .selfie)
                    KYCDocumentUploadWorker().executeMultipartRequest(data: data) { result in
                        switch result {
                        case .success:
                            self?.finish(viewAction: .init())
                        case .failure(let error):
                            self?.presenter?.presentError(actionResponse: .init(error: error))
                        }
                    }
                    
                case .failure(let error):
                    self?.presenter?.presentError(actionResponse: .init(error: error))
                }
            }
        }
    }
    
    func confirmPhoto(viewAction: KYCDocumentPickerModels.ConfirmPhoto.ViewAction) {
        guard let photo = viewAction.photo else { return }
        
        photo.compress(to: 1024*1024) { [weak self] image in
            if self?.dataStore?.front == nil {
                self?.dataStore?.front = image
            } else if self?.dataStore?.document != .passport,
                      self?.dataStore?.back == nil {
                self?.dataStore?.back = image
            } else if self?.dataStore?.selfie == nil {
                self?.dataStore?.selfie = image
            }
            self?.takePhoto(viewAction: .init())
        }
    }
    
    func finish(viewAction: KYCDocumentPickerModels.Finish.ViewAction) {
        KYCSubmitWorker().execute { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.presentFinish(actionResponse: .init())
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    // MARK: - Aditional helpers
}
