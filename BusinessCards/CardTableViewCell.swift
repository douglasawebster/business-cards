//
//  CardTableViewCell.swift
//  BusinessCards
//
//  Created by Douglas Webster on 12/17/20.
//

import Foundation
import UIKit

class CardTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cardView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        var cardViewFrame = CGRect.zero
        cardViewFrame.origin.x = bounds.origin.x
        cardViewFrame.origin.y = bounds.origin.y
        cardViewFrame.size.width = min(375, bounds.width*0.8)
        cardViewFrame.size.height = 500
        cardView.frame = cardViewFrame
    }
        
    var companyName: String = "" {
        didSet {
            self.companyNameLabel.text = companyName
        }
    }
    
    private lazy var companyNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var cardView: UIView = {
        let cardView = UIView()
        cardView.backgroundColor = .purple
        return cardView
    }()
    
}
