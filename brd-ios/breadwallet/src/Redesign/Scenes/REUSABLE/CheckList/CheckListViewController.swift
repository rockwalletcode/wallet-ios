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
    
    // MARK: - Overrides
    
    override func setupVerticalButtons() {
        super.setupVerticalButtons()
        
        verticalButtons.wrappedView.configure(with: .init(buttons: [Presets.Button.primary]))
        verticalButtons.wrappedView.setup(with: .init(buttons: [.init(title: L10n.Button.confirm,
                                                                      callback: { [weak self] in
            self?.buttonTapped()
        })
        ]))
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
