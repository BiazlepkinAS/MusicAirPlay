
import UIKit

class MainViewController: UIViewController {
    
    let album = Album.get()
    var bleManager = BLEManager()
    
    
    private lazy var tableView: UITableView = {
       let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(AlbumTableViewCell.self, forCellReuseIdentifier: "cell")
        table.estimatedRowHeight = 110
        table.rowHeight = UITableView.automaticDimension
        table.tableFooterView = UIView()
        table.backgroundColor = #colorLiteral(red: 0.2935881019, green: 0.7225453258, blue: 0.7436243296, alpha: 1)
        table.separatorColor = .secondarySystemBackground
        return table
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        setupView()
        view.backgroundColor = #colorLiteral(red: 0.1211808696, green: 0.377275914, blue: 0.4133348465, alpha: 1)
        
        


        
    }
    
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        ])
    }
    
    private func setupView() {
        self.title = "My Player"
        view.addSubview(tableView)
        setupConstrains()
        
    }
    
    @objc func bluetoothChanged(notification: NSNotification) {

        if let status = notification.userInfo?["statusString"] as? String {
            print("Bluetooth status = \(status)")
        }


}
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.count
    }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AlbumTableViewCell else {
        return UITableViewCell()
    }
    cell.album = album[indexPath.row]
    return cell
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = MusicPlayerViewController(album: album[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        present(viewController, animated: true, completion: nil)
    }

}
