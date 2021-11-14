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
    
    let user1 = [
        "wallet1" : [
            "firstName" : "Douglas",
            "lastName" : "Webster",
            "position" : "CEO",
            "companyName" : "Apple",
            "email" : "douglas.alan.webster@gmail.com",
            "phoneNumber" : "(619) 871-0071",
            "fax" : "(619) 871-0071",
            "address" : "2111 Via Don Benito",
            "website" : "www.businesscards.com"
        ]
    ]
    
    let user2 = [
        "wallet1" : [
            "firstName" : "John",
            "lastName" : "Doe",
            "position" : "CEO",
            "companyName" : "Apple",
            "email" : "douglas.alan.webster@gmail.com",
            "phoneNumber" : "(619) 871-0071",
            "fax" : "(619) 871-0071",
            "address" : "2111 Via Don Benito",
            "website" : "www.businesscards.com"
        ]
    ]
    
    let user3 = [
        "wallet1" : [
            "firstName" : "Nico",
            "lastName" : "Ivanov",
            "position" : "CEO",
            "companyName" : "Apple",
            "email" : "douglas.alan.webster@gmail.com",
            "phoneNumber" : "(619) 871-0071",
            "fax" : "(619) 871-0071",
            "address" : "2111 Via Don Benito",
            "website" : "www.businesscards.com"
        ]
    ]
    
    let user4: [String:[String:String]] = [
        "wallet1" : [
            "firstName" : "Luke",
            "lastName" : "Andrews",
            "position" : "CEO",
            "companyName" : "Apple",
            "email" : "douglas.alan.webster@gmail.com",
            "phoneNumber" : "(619) 871-0071",
            "fax" : "(619) 871-0071",
            "address" : "2111 Via Don Benito",
            "website" : "www.businesscards.com"
        ]
    ]
    
    let user5 = [
        "wallet1" : [
            "firstName" : "John",
            "lastName" : "Murphey",
            "position" : "CEO",
            "companyName" : "Apple",
            "email" : "douglas.alan.webster@gmail.com",
            "phoneNumber" : "(619) 871-0071",
            "fax" : "(619) 871-0071",
            "address" : "2111 Via Don Benito",
            "website" : "www.businesscards.com"
        ]
    ]
    
    let user6 = [
        "wallet1" : [
            "firstName" : "Jake",
            "lastName" : "Marshal",
            "position" : "CEO",
            "companyName" : "Apple",
            "email" : "douglas.alan.webster@gmail.com",
            "phoneNumber" : "(619) 871-0071",
            "fax" : "(619) 871-0071",
            "address" : "2111 Via Don Benito",
            "website" : "www.businesscards.com"
        ]
    ]
        
    var data = [[String:[String:String]]]()
    
    var filteredData = [[String:[String:String]]]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Wallet"
        let tabTitle = NSLocalizedString("Wallet", comment: "")
        let image = UIImage(systemName: "wallet.pass")?.withTintColor(.systemPink)
        self.tabBarItem = UITabBarItem(title: tabTitle, image: image, selectedImage: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill")?.withTintColor(.purple), style: .plain, target: self, action: #selector(test))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(signOut))
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.searchBar.searchTextField.backgroundColor = Theme.searchBarTextFieldColor
        
        self.data.append(user1)
        self.data.append(user2)
        self.data.append(user3)
        self.data.append(user4)
        self.data.append(user5)
        self.data.append(user5)
    }
    
    @objc func test() {
        print("here")
    }
    
    @objc func signOut() {
        AuthProvider.signOut()
    }
    
    @objc func pickerViewDidChange() {
        currentPickerIndex = pickerView.selectedSegmentIndex
        self.filter(searchText: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = Theme.backgroundColor
        view.addSubview(scrollView)
        scrollView.addSubview(pickerView)
        scrollView.addSubview(collectionView)
        //view.addSubview(pickerView)
        //view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        searchController.becomeFirstResponder()
    }
    
    private let padding: CGFloat = 10
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var insets = view.safeAreaInsets
        insets.top += padding
        var availableBounds = view.bounds.inset(by: insets)
        
        scrollView.frame = availableBounds
            
        let pickerViewSize = pickerView.intrinsicContentSize
        var pickerViewFrame = CGRect.zero
        pickerViewFrame.origin.x = availableBounds.midX - (pickerViewSize.width/2.0)
        pickerViewFrame.origin.y = availableBounds.minY
        pickerViewFrame.size = pickerViewSize
        pickerView.frame = pickerViewFrame
        
        let pickerViewOffset = pickerViewFrame.height + padding
        availableBounds.origin.y += pickerViewOffset
        availableBounds.size.height -= pickerViewOffset
        
        collectionView.frame = availableBounds
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private var currentPickerIndex = 0
    private lazy var pickerView: UISegmentedControl = {
        let items = ["Name", "Surname", "Company", "Date"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(pickerViewDidChange), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = currentPickerIndex
        segmentedControl.selectedSegmentTintColor = Theme.keyColor
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        return segmentedControl
    }()
    
    private let walletCellIdentifier = "WalletCellIdentifier"
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = self.cellSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(WalletCollectionViewCell.self, forCellWithReuseIdentifier: self.walletCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private var cachedCellSize: CGSize?
    private var cellSize: CGSize {
        if let existingSize = cachedCellSize {
            return existingSize
        } else {
            let calculatedSize = WalletCollectionViewCell.minimumContentSize()
            cachedCellSize = calculatedSize
            return calculatedSize
        }
    }
    
}

extension WalletViewController: UICollectionViewDelegate {
    
}

extension WalletViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: walletCellIdentifier, for: indexPath) as! WalletCollectionViewCell
        let card = data[indexPath.row]["wallet1"]
        cell.firstName = card?["firstName"] ?? ""
        cell.lastName = card?["lastName"] ?? ""
        cell.positionName = card?["position"] ?? ""
        cell.companyName = card?["companyName"] ?? ""
        cell.email = card?["email"] ?? ""
        cell.phoneNumber = card?["phoneNumber"] ?? ""
        cell.fax = card?["fax"] ?? ""
        cell.address = card?["address"] ?? ""
        cell.website = card?["website"] ?? ""
        return cell
    }
    
}

extension WalletViewController: UISearchBarDelegate {
    
    
    
}

extension WalletViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        filter(searchText: searchText)
    }
    
    func filter(searchText: String) {
        data.sort(by: { (lhs: [String:[String:String]],rhs:[String:[String:String]]) in
            if currentPickerIndex == 0 {
                let lhsFirstName = lhs["wallet1"]?["firstName"] ?? ""
                let rhsFirstName = rhs["wallet1"]?["firstName"] ?? ""
                return lhsFirstName < rhsFirstName
            } else {
                let lhsFirstName = lhs["wallet1"]?["lastName"] ?? ""
                let rhsFirstName = rhs["wallet1"]?["lastName"] ?? ""
                return lhsFirstName < rhsFirstName
            }
            
        })
        /*let filtered = data.filter({ (item) in
            return false
        })*/
        self.filteredData = data
        collectionView.reloadData()
    }
    
}
