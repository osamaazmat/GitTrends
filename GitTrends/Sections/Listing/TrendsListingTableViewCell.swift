//
//  TrendsListingTableViewCell.swift
//  GitTrends
//
//  Created by Osama Azmat Khan on 23/11/2021.
//

import UIKit
import SDWebImage

class TrendsListingTableViewCell: UITableViewCell {

    // MARK: Outlets And Properties
    static let cellNibName = "TrendsListingTableViewCell"
    static let cellReuseIdentifier = "trendsListingTableViewCell"
    
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var mainDescLabel: UILabel!
    @IBOutlet weak var mainDetailsLabel: UILabel!
    @IBOutlet weak var languageNameLabel: UILabel!
    @IBOutlet weak var numberOfStarsLabel: UILabel!
    @IBOutlet weak var extraInfoView: UIView!
    @IBOutlet weak var languageView: UIView!
    
    // MARK: Cell LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        languageView.layer.cornerRadius = languageView.layer.frame.height / 2
        languageView.clipsToBounds = true
    }
    
    func configureCell(with dataModel: Item) {
        selectionStyle             = .none
        ownerNameLabel.text        = dataModel.owner?.login
        mainDescLabel.text         = dataModel.fullName
        mainDetailsLabel.text      = dataModel.itemDescription
        languageNameLabel.text     = dataModel.language
        numberOfStarsLabel.text    = "\(dataModel.stargazersCount)"
        
        let imgUrl = URL.init(string: dataModel.owner?.avatarURL ?? "")
        ownerImageView.sd_setImage(with: imgUrl, placeholderImage: UIImage.init(named: "user_placeholder_icon"), completed: nil)
    }
    
    func showExtraData(shouldAnimate: Bool = true) {
        mainDetailsLabel.isHidden = false
        extraInfoView.isHidden = false
        
        if shouldAnimate {
            UIView.animate(withDuration: 0.2) {
                self.contentView.layoutIfNeeded()
            }
        }
    }
    
    func hideExtraData(shouldAnimate: Bool = true) {
        mainDetailsLabel.isHidden = true
        extraInfoView.isHidden = true
        
        if shouldAnimate {
            UIView.animate(withDuration: 0.2) {
                self.contentView.layoutIfNeeded()
            }
        }
    }
}
