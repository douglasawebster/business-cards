//
//
//  WallerViewController.swift
//  BusinessCards
//
//  Created by Douglas Webster on 7/30/21.
//

import Foundation
import UIKit

class WalletViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Wallet"
        let tabTitle = NSLocalizedString("Wallet", comment: "")
        let image = UIImage(systemName: "wallet.pass")
        image?.withTintColor(.blue)
        self.tabBarItem = UITabBarItem(title: tabTitle, image: image, selectedImage: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = Theme.backgroundColor
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private let walletCellIdentifier = "WalletCellIdentifier"
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isAccessibilityElement = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.walletCellIdentifier)
        return tableView
    }()
    
}

extension WalletViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.walletCellIdentifier)!
        return cell
    }
    
    
}

extension WalletViewController: UITableViewDelegate {
    
    
    
}
