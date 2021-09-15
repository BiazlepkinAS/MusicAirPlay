
import UIKit

final class MusicPlayerViewController: UIViewController {
    
    var album: Album
    
    private lazy var mediaPlayer: MediaPlayer = {
        let player = MediaPlayer(album: album)
        player.translatesAutoresizingMaskIntoConstraints = false
        
        return player
    }()
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = #colorLiteral(red: 0.2505040467, green: 0.6873538494, blue: 0.6911943555, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mediaPlayer.play()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func setupView() {
        addBlurredView()
        view.addSubview(mediaPlayer)
        setupConstraints()
        
    }
    
    private func addBlurredView() {
        if !UIAccessibility.isReduceMotionEnabled {
            self.view.backgroundColor = UIColor.clear
            let bluerEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let bluerEffectView = UIVisualEffectView(effect: bluerEffect)
            bluerEffectView.frame = self.view.bounds
            bluerEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            view.addSubview(bluerEffectView)
        } else {
            view.backgroundColor = UIColor.clear
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mediaPlayer.topAnchor.constraint(equalTo: view.topAnchor),
            mediaPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mediaPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mediaPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
}
