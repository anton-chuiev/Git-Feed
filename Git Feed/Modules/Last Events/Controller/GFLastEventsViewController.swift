//
//  EventsViewController.swift
//  Git Feed
//
//  Created by Anton Chuev on 11/12/18.
//  Copyright © 2018 Anton Chuiev. All rights reserved.
//

import RxSwift

final class GFLastEventsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = GFLastEventsViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        viewModel.models.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        viewModel.loadSavedEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
    }
    
    fileprivate func configureUI() {
        title = "RxSwift"
        
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        refreshControl.tintColor = UIColor.darkText
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib.init(nibName: "GFEventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
    }
    
    @objc fileprivate func refresh() {
        viewModel.fetch()
    }
}

extension GFLastEventsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.models.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! GFEventCell
        let cellViewModel = viewModel.models.value[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
