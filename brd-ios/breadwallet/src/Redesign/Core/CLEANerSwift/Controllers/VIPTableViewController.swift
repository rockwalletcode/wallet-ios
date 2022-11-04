//
//  VIPTableViewController.swift
//  
//
//  Created by Rok Cresnik on 01/12/2021.
//

import UIKit

class VIPTableViewController<C: CoordinatableRoutes,
                             I: Interactor,
                             P: Presenter,
                             DS: BaseDataStore & NSObject>: VIPViewController<C, I, P, DS>,
                                                            UITableViewDelegate,
                                                            UITableViewDataSource {
    override var isModalDismissableEnabled: Bool {
        return true
    }

    var sections: [AnyHashable] = []
    var sectionRows: [AnyHashable: [Any]] = [:]

    // MARK: LazyUI
    lazy var tableView: ContentSizedTableView = {
        var tableView = ContentSizedTableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self

        // this prevents the top offset on tableViews
        let zeroView = UIView(frame: .init(origin: .zero, size: .init(width: 0, height: CGFloat.leastNonzeroMagnitude)))
        tableView.tableHeaderView = zeroView
        tableView.tableFooterView = zeroView
        tableView.estimatedSectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.estimatedRowHeight = CGFloat.leastNormalMagnitude
        tableView.estimatedSectionFooterHeight = CGFloat.leastNormalMagnitude

        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension

        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var contentShadowView: UIView = {
        var contentShadowView = UIView()
        contentShadowView.backgroundColor = LightColors.Background.one
        contentShadowView.clipsToBounds = true
        contentShadowView.layer.cornerRadius = CornerRadius.common.rawValue
        contentShadowView.layer.shadowRadius = contentShadowView.layer.cornerRadius * 3
        contentShadowView.layer.shadowOpacity = 0.1
        contentShadowView.layer.shadowOffset = CGSize(width: 0, height: 8)
        contentShadowView.layer.shadowColor = UIColor(red: 0.043, green: 0.082, blue: 0.165, alpha: 1.0).cgColor
        contentShadowView.layer.masksToBounds = false
        contentShadowView.layer.shouldRasterize = true
        contentShadowView.layer.rasterizationScale = UIScreen.main.scale
        return contentShadowView
    }()
    
    var topInsetValue: CGFloat = 0
    
    // MARK: Lifecycle
    override func setupSubviews() {
        super.setupSubviews()
        
        topInsetValue = sceneLeftAlignedTitle == nil ? 0 : Margins.extraHuge.rawValue + 28
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.addSubview(leftAlignedTitleLabel)
        leftAlignedTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.top)
            make.height.greaterThanOrEqualTo(topInsetValue)
            make.width.lessThanOrEqualTo(tableView.snp.width).inset(Margins.large.rawValue) // TODO: Trailing does not work. Why?
            make.leading.equalToSuperview().inset(Margins.large.rawValue)
        }
        
        tableView.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.top).inset(-Margins.large.rawValue)
            make.leading.equalTo(leftAlignedTitleLabel.snp.trailing).inset(-Margins.medium.rawValue)
            make.trailing.equalToSuperview().inset(Margins.large.rawValue)
        }
        
        tableView.contentInset.top = topInsetValue
        
        view.backgroundColor = LightColors.Background.two
    }
    
    func setRoundedShadowBackground() {
        let small = Margins.small.rawValue
        let large = Margins.large.rawValue
        let extraLarge = Margins.extraLarge.rawValue
        let huge = Margins.huge.rawValue
        let extraHuge = Margins.extraHuge.rawValue

        view.addSubview(contentShadowView)
        tableView.heightUpdated = { height in
            self.contentShadowView.snp.remakeConstraints { make in
                make.leading.equalTo(large)
                make.trailing.equalTo(-large)
                make.top.equalTo(self.tableView.snp.top).inset(self.topInsetValue)
                make.height.equalTo(height + extraLarge)
                make.width.equalTo(self.tableView.snp.width).offset(extraHuge)
            }
        }
        contentShadowView.layer.zPosition = tableView.layer.zPosition - 1
        contentShadowView.isUserInteractionEnabled = false
        
        tableView.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: self.topInsetValue,
                                                             left: extraHuge,
                                                             bottom: 0,
                                                             right: extraHuge))
        }
        
        tableView.contentInset.top += small
        
        tableView.clipsToBounds = false
        tableView.layer.masksToBounds = false
        leftAlignedTitleLabel.snp.updateConstraints { make in
            make.bottom.equalTo(tableView.snp.top).inset(-small)
            make.leading.equalToSuperview().inset(-large)
        }
        
        tableView.verticalScrollIndicatorInsets.right = -huge
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentShadowView.transform = .init(translationX: 0, y: -scrollView.contentOffset.y - tableView.contentInset.top)
    }
    
    // MARK: ResponseDisplay
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return sectionRows[section]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return .init(frame: .zero)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return .init(frame: .zero)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    func tableView(_ tableView: UITableView, didSelectHeaderIn section: Int) {}

    func tableView(_ tableView: UITableView, didSelectFooterIn section: Int) {}
}
