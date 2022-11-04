//
//  CheckListViewController.swift
//  breadwallet
//
//  Created by Rok on 06/06/2022.
//
//

import UIKit

class CheckListViewController: BaseTableViewController<BaseCoordinator,
                               CheckListInteractor,
                               CheckListPresenter,
                               CheckListStore>,
                               CheckListResponseDisplays {
    typealias Models = CheckListModels

    override var sceneLeftAlignedTitle: String? { return "Checklist base VC" }
    var checklistTitle: LabelViewModel { return .text("OVERRIDE IN SUBCLASS") }
    var checkmarks: [ChecklistItemViewModel] { return [] }
    
    var continueCallback: (() -> Void)?
    
    lazy var confirmButton: WrapperView<FEButton> = {
        let button = WrapperView<FEButton>()
        return button
    }()
    
    // MARK: - Overrides
    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.centerX.leading.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        confirmButton.wrappedView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.Common.largeButton.rawValue)
            make.edges.equalTo(confirmButton.snp.margins)
        }
        
        tableView.snp.remakeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top)
        }
        
        confirmButton.wrappedView.setup(with: .init(title: L10n.Button.confirm.uppercased()))
        
        confirmButton.setupCustomMargins(top: .small, leading: .large, bottom: .large, trailing: .large)
        confirmButton.wrappedView.configure(with: Presets.Button.primary)
        confirmButton.wrappedView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func prepareData() {
        sections = [
            Models.Sections.title,
            Models.Sections.checkmarks
        ]
        
        sectionRows = [
            Models.Sections.title: [checklistTitle],
            Models.Sections.checkmarks: checkmarks
        ]
        
        super.prepareData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Sections {
        case .title:
            cell =  self.tableView(tableView, labelCellForRowAt: indexPath)
            (cell as? WrapperTableViewCell<FELabel>)?.wrappedView.configure(with: .init(font: Fonts.Title.six, textColor: LightColors.Text.three))
            
        case .checkmarks:
            cell = self.tableView(tableView, checkmarkCellForRowAt: indexPath)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setBackground(with: Presets.Background.transparent)
        cell.setupCustomMargins(vertical: .huge, horizontal: .large)
        
        return cell
    }
    
    // MARK: - User Interaction
    override func buttonTapped() {
        super.buttonTapped()
    }
    
    // MARK: - CheckListResponseDisplay
    
    // MARK: - Additional Helpers
}
