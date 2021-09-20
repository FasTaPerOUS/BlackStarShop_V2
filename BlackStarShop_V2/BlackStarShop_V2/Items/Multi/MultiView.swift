//
//  MultiView.swift
//  BlackStarShop_V2
//
//  Created by Norik on 06.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

final class MultiView: UIView {
    
    //MARK: - Dependencies
    
    weak var viewController: MultiViewController?
    
    //MARK: - UI
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var infoTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MultiTableViewCell.self, forCellReuseIdentifier: "Multi cell")
        return tableView
    }()
    
    //MARK: - Init
    
    init(viewController: MultiViewController) {
        self.viewController = viewController
        super.init(frame: .zero)
        addSubviews()
        backgroundColor = infoTableView.backgroundColor
        setTitleLabelText()
        setupConstraints()
        addDelegateAndDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(infoTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            infoTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            infoTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }
    
    private func setTitleLabelText() {
        switch viewController?.controllerType {
        case "Color":
            titleLabel.text = "Выберите цвет"
        case "Size":
            titleLabel.text = "Выберите размер"
        default:
            titleLabel.text = "Упс("
        }
    }
    
    private func byeTitleText() {
        switch viewController?.controllerType {
        case "Color":
            titleLabel.text = "Цвет выбран"
        case "Size":
            titleLabel.text = "Размер выбран"
        default:
            titleLabel.text = "Упс("
        }
    }
}

extension MultiView: UITableViewDelegate, UITableViewDataSource {
    
    private func addDelegateAndDataSource() {
        infoTableView.delegate = self
        infoTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewController?.countInfo() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Multi cell")
            as? MultiTableViewCell else { return UITableViewCell() }
        cell.label.text = viewController?.getLabel(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        byeTitleText()
        viewController?.delegate(index: indexPath.row)
        UIView.animate(withDuration: 0.5, animations: { self.titleLabel.alpha = 0 }) { [weak self] (f) in
            self?.viewController?.navigationController?.popViewController(animated: f)
        }
    }
}
