//
//  ChannelListController.swift
//  FMWithXML
//
//  Created by Ankit on 14/01/22.
//

import UIKit

class ListViewController : UIViewController {
    let url : URL
    let viewModel : ListViewModel
    required init?(coder: NSCoder) {
        fatalError("Cannot user init with coder")
    }
    
    init(url: URL) {
        self.url = url
        viewModel = ListViewModel(url: url, networkManager: NetworkManager.shared)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 60.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: "ChannelTableViewCell")
        
        return tableView
    }()
    
    var channels = [Channel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        view.addSubview(tableView)
        view.addConstraints([tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0), tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0), tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)])
        
        viewModel.getChannels()
    }
}


extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfChannels()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = viewModel.channel(at: indexPath)
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelTableViewCell", for: indexPath)
        cell.textLabel?.text = channel.StationName
        cell.detailTextLabel?.text = channel.StationId
        if let url = URL(string: channel.Logo ?? "") {
            cell.imageView?.imageFromServerURL(url: url, placeholderImage: UIImage(named: "placeholder"))
        }
        return cell
    }
    
}



extension ListViewController : RefreshData {
    func refreshData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
