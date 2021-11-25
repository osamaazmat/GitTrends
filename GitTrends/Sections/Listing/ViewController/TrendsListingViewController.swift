//
//  TrendsListingViewController.swift
//  GitTrends
//
//  Created by Osama Azmat Khan on 20/11/2021.
//

import UIKit
import SkeletonView
import Lottie

class TrendsListingViewController: UIViewController {
    
    // MARK: Outlets And Properties
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var retryView: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    
    var animationView: AnimationView!
    
    var trendsListingViewModel: TrendsListingViewModel!
    let refreshControl = UIRefreshControl()
    var shouldAnimate = true
    
    // MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup Methods
extension TrendsListingViewController {
    
    func setupUI() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        self.menuBtn.setTitle("", for: .normal)

        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        self.tableView.register(UINib(nibName: TrendsListingTableViewCell.cellNibName, bundle: nil), forCellReuseIdentifier: TrendsListingTableViewCell.cellReuseIdentifier)
        
        self.tableView.dataSource   = self
        self.tableView.delegate     = self
        
        self.tableView.reloadData()
    }
    
    func showRetryView() {
        setupRetryBtn()
        setupLottieAnimation()
        self.retryView.isHidden = false
    }
    
    func hideRetryView() {
        self.retryView.isHidden = true
        
        if let animationView = animationView {
            animationView.stop()
            animationView.removeFromSuperview()
        }
    }
    
    func setupRetryBtn() {
        retryButton.layer.borderWidth = 2
        retryButton.layer.cornerRadius = 5
        retryButton.layer.borderColor = UIColor().colorWithHexString(hexString: "#1BEA7F").cgColor
        retryButton.clipsToBounds = true
    }
    
    func setupLottieAnimation() {
        animationView = .init(name: "retry_json")
        
        if let animationView = animationView {
            animationView.frame = animationContainerView.bounds
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.animationSpeed = 1
            self.animationContainerView.addSubview(animationView)
            animationView.play()
        }
    }
}

// MARK: - Action Methods
extension TrendsListingViewController {
    
    @objc func refresh(_ sender: AnyObject) {
        self.trendsListingViewModel.getTrendsRepositories()
    }
    
    @IBAction func onPressRetryBtn(_ sender: Any) {
        hideRetryView()
        self.trendsListingViewModel.getTrendsRepositories()
    }
}

// MARK: - View Model Delegate
extension TrendsListingViewController: TrendsListingViewModelDelegate {
    func successResponse(withData: GitHubRepoModel) {
        DispatchQueue.main.async {
            self.hideRetryView()
            self.shouldAnimate = false
            
            self.trendsListingViewModel.setupLocalDataStash()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func failureResponse() {
        DispatchQueue.main.async {
            self.showRetryView()
        }
    }
}

// MARK: - TableView Delegate
extension TrendsListingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentCell = tableView.cellForRow(at: indexPath) as? TrendsListingTableViewCell {
            let gitHubModel = self.trendsListingViewModel.gitHubRepoData.items[indexPath.item]
            
            for i in 0..<self.trendsListingViewModel.trendsListingList.count {
                let trendModel = self.trendsListingViewModel.trendsListingList[i]
                if trendModel.id == gitHubModel.id {
                    if trendModel.isExpanded {
                        currentCell.hideExtraData()
                        tableView.beginUpdates()
                        tableView.endUpdates()
                        trendModel.isExpanded = false
                    } else {
                        currentCell.showExtraData()
                        tableView.beginUpdates()
                        tableView.endUpdates()
                        trendModel.isExpanded = true
                    }
                }
            }
        }
    }
}

extension TrendsListingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.shouldAnimate {
            return 10
        } else {
            return self.trendsListingViewModel.gitHubRepoData.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendsListingTableViewCell.cellReuseIdentifier, for: indexPath) as? TrendsListingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.ownerImageView.layer.cornerRadius = cell.ownerImageView.frame.size.width / 2
        cell.ownerImageView.clipsToBounds = true
        
        if !self.shouldAnimate {
            cell.hideSkeleton()
            
            let itemModel = self.trendsListingViewModel.gitHubRepoData.items[indexPath.item]
            for i in 0..<self.trendsListingViewModel.trendsListingList.count {
                let trendModel = self.trendsListingViewModel.trendsListingList[i]
                if trendModel.id == itemModel.id {
                    if trendModel.isExpanded {
                        cell.showExtraData(shouldAnimate: false)
                    } else {
                        cell.hideExtraData(shouldAnimate: false)
                    }
                }
            }
            
            cell.configureCell(with: itemModel)
        } else {
            cell.hideExtraData()
            cell.showAnimatedGradientSkeleton()
        }
        
        return cell
    }
}
