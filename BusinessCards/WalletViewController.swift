//
//  WalletViewController.swift
//  BusinessCards
//
//  Created by Douglas Webster on 12/17/20.
//

import Foundation
import UIKit
import Firebase

class WalletViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Cards"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var cards = [Card]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.backgroundColor
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cardCell = tableView.dequeueReusableCell(withIdentifier: self.cardCellIdentifier, for: indexPath) as! CardTableViewCell
        let cardData = cards[indexPath.row]
        cardCell.companyName = cardData.companyName
        cardCell.firstName = cardData.firstName
        cardCell.middleName = cardData.middleName
        cardCell.lastName = cardData.lastName
        cardCell.position = cardData.position
        cardCell.phoneNumber = cardData.phoneNumber
        cardCell.fax = cardData.fax
        cardCell.email = cardData.email
        cardCell.address = cardData.address
        return cardCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CardTableViewCell.preferredRowHeight()
    }
    
    private let cardCellIdentifier = "WalletCellIdentifier"
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: self.cardCellIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
}
