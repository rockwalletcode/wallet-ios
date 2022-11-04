//
//  TxMemoCell.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2018-01-02.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class TxMemoCell: TxDetailRowCell {
    
    // MARK: - Views
    
    fileprivate let textView = UITextView()
    fileprivate let placeholderLabel = UILabel(font: Fonts.Body.two, color: LightColors.Text.two)
    
    // MARK: - Vars

    private var viewModel: TxDetailViewModel!
    private weak var tableView: UITableView!
    
    // MARK: - Init
    
    override func addSubviews() {
        super.addSubviews()
        container.addSubview(textView)
        textView.addSubview(placeholderLabel)
    }
    
    override func addConstraints() {
        super.addConstraints()
        
        textView.constrain([
            textView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Margins.large.rawValue),
            textView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textView.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        placeholderLabel.constrain([
            placeholderLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            placeholderLabel.widthAnchor.constraint(equalTo: textView.widthAnchor)
            ])
        placeholderLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override func setupStyle() {
        super.setupStyle()

        textView.font = Fonts.Body.two
        textView.textColor = LightColors.Text.two
        textView.textAlignment = .right
        textView.isScrollEnabled = false
        textView.returnKeyType = .done
        textView.delegate = self
        
        placeholderLabel.textAlignment = .right
        placeholderLabel.text = L10n.TransactionDetails.commentsPlaceholder
    }
    
    // MARK: -
    
    func set(viewModel: TxDetailViewModel, tableView: UITableView) {
        self.tableView = tableView
        self.viewModel = viewModel
        textView.text = viewModel.comment
        placeholderLabel.isHidden = !textView.text.isEmpty
        if viewModel.gift != nil {
            textView.isEditable = false
            textView.isSelectable = false
        }
    }
    
    fileprivate func saveComment(comment: String) {
        guard let kvStore = Backend.kvStore,
              let tx = viewModel.tx else { return }
        
        tx.save(comment: comment, kvStore: kvStore)
        Store.trigger(name: .txMetaDataUpdated(tx.hash))
    }
}

extension TxMemoCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { return }
        saveComment(comment: text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            textView.resignFirstResponder()
            return false
        }
        
        let count = (textView.text ?? "").utf8.count + text.utf8.count
        if count > C.maxMemoLength {
            return false
        } else {
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        // trigger cell resize
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
