//
//  BaseInfoViewController.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 13.7.22.
//
//

import UIKit

class BaseInfoViewController: BaseTableViewController<BaseCoordinator,
                              BaseInfoInteractor,
                              BaseInfoPresenter,
                              BaseInfoStore>,
                              BaseInfoResponseDisplays {
    typealias Models = BaseInfoModels
    
    var imageName: String? { return "statusIcon" }
    var titleText: String? { return "OVERRIDE IN SUBCLASS" }
    var descriptionText: String? { return "THIS AS WELL" }
    
    var buttonViewModels: [ButtonViewModel] { return [] }
    var buttonConfigs: [ButtonConfiguration] {
        return [
            Presets.Button.primary,
            Presets.Button.noBorders
        ]
    }
    var buttonCallbacks: [(() -> Void)] { return [] }
    
    private lazy var buttonStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.extraSmall.rawValue
        return view
    }()
    
    // MARK: - Overrides
    
    override var closeImage: UIImage? { return .init(named: "")}
    
    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(buttonStack)
        tableView.snp.removeConstraints()
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(ViewSizes.extraExtraHuge.rawValue * 2)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(buttonStack.snp.top)
        }
        
        for (index, model) in buttonViewModels.enumerated() {
            let config = buttonConfigs.indices.contains(index) ? buttonConfigs[index] : buttonConfigs.first
            let button = FEButton()
            button.configure(with: config ?? Presets.Button.primary)
            button.setup(with: model)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.height.equalTo(ViewSizes.Common.largeButton.rawValue)
            }
            buttonStack.addArrangedSubview(button)
        }
        let count = CGFloat(buttonStack.arrangedSubviews.count)
        var height = ViewSizes.Common.largeButton.rawValue * count
        height += Margins.extraSmall.rawValue * (count - 1)
        
        buttonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(Margins.large.rawValue)
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(height)
        }
    }
    
    override func prepareData() {
        super.prepareData()
        
        for (button, model) in zip(buttonStack.arrangedSubviews, buttonViewModels) {
            (button as? FEButton)?.setup(with: model)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] as? Models.Section {
        case .image:
            return imageName == nil ? 0 : 1
            
        case .title:
            return titleText == nil ? 0 : 1
            
        case .description:
            return descriptionText == nil ? 0 : 1
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Section {
        case .image:
            cell = self.tableView(tableView, coverCellForRowAt: indexPath)
            
        case .title:
            cell = self.tableView(tableView, titleLabelCellForRowAt: indexPath)
            
        case .description:
            cell = self.tableView(tableView, descriptionLabelCellForRowAt: indexPath)
            
        default:
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        cell.setupCustomMargins(all: .extraHuge)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, coverCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WrapperTableViewCell<FEImageView> = tableView.dequeueReusableCell(for: indexPath),
              let value = imageName
        else { return UITableViewCell() }
        
        cell.setup { view in
            view.configure(with: Presets.Background.transparent)
            view.setup(with: .imageName(value))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleLabelCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let value = titleText,
              let cell: WrapperTableViewCell<FELabel> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init(font: Fonts.Title.six, textColor: LightColors.Text.three, textAlignment: .center))
            view.setup(with: .text(value))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, descriptionLabelCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let value = descriptionText,
              let cell: WrapperTableViewCell<FELabel> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init(font: Fonts.Body.two, textColor: LightColors.Text.two, textAlignment: .center))
            view.setup(with: .text(value))
            view.setupCustomMargins(vertical: .extraHuge, horizontal: .extraHuge)
            view.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(Margins.extraHuge.rawValue)
            }
        }
        
        return cell
    }
    
    // MARK: - User Interaction
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let index = buttonStack.arrangedSubviews.firstIndex(of: sender),
              buttonCallbacks.indices.contains(index)
        else {
            buttonCallbacks.first?()
            return
        }
        buttonCallbacks[index]()
    }
    
    // MARK: - SwapInfoResponseDisplay
    
    // MARK: - Additional Helpers
}
