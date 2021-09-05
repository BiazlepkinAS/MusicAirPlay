
import UIKit

class AlbumTableViewCell: UITableViewCell {
    var album: Album? {
        didSet {
            if let album = album {
                albumCover.image = UIImage(named: album.image)
                albumName.text = album.name
                songsCount.text = "\(album.songs.count) Song"
            }
        }
    }
    
    private lazy var albumCover: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 24
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        return image
    }()
    
    private lazy var albumName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(named: "titleColor")
        return label
    }()
    
    private lazy var songsCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textColor = UIColor(named: "subtitleColor")
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        
    }
    private func setupView() {
        [albumCover, albumName, songsCount].forEach { (v) in
            contentView.addSubview(v)
        }
        setupConstrains()
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            albumCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            albumCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            albumCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            albumCover.widthAnchor.constraint(equalToConstant: 90),
            albumCover.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            albumName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            albumName.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 18),
            albumName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            songsCount.topAnchor.constraint(equalTo: albumName.bottomAnchor, constant: 10),
            songsCount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
            songsCount.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 18),
            songsCount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
