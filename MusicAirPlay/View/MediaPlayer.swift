
import UIKit
import AVKit
import MediaPlayer

final class MediaPlayer: UIView {
    
    var album: Album
    var currentVolume: Float
    var bleManager: BLEManager!
    private var player = AVAudioPlayer()
    private var timer: Timer?
    private var playingIndex = 0
    
    private lazy var albumCover: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 200
        return image
    }()
    
    private lazy var volumeBar:UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = currentVolume
        slider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        return slider
    }()
    
    private lazy var progressBar: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor(named: "subtitleColor")
        slider.addTarget(self, action: #selector(progressScrubbed), for: .valueChanged)
        return slider
    }()
    
    private lazy var albumName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private lazy var elapsedTimerLabel: UILabel = {
        let  label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.text = "00:00"
        return label
    }()
    
    private lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.text = "00:00"
        return label
    }()
    
    private lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private lazy var previousButton: UIButton = {
        let button  = UIButton()
        button.translatesAutoresizingMaskIntoConstraints  = false
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(didTapPrevious), for: .touchUpInside)
        return button
    }()
    
    private lazy var playPauseButton:  UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 80)
        button.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()
    
    private lazy var blueToothButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "tv.and.hifispeaker.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(blueToothSearch), for: .touchUpInside)
        return button
    }()
    private lazy var airPlayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "airplayaudio", withConfiguration: config), for: .normal)
        let buttonFrame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.tintColor = .white
        button.addTarget(self, action: #selector(airPlayMode), for: .touchUpInside)
        return button
    }()
    
    private lazy var controlStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [airPlayButton, previousButton, playPauseButton, nextButton, blueToothButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 13
        return stack
    }()
    
    init(album: Album) {
        self.album = album
        self.currentVolume = 0.5
        super.init(frame: .zero)
        setupView()
        bleManager = BLEManager()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        albumName.text = album.name
        albumCover.image = UIImage(named: album.image)
        setupPlayer(song: album.songs[playingIndex])
        [albumName, songNameLabel, artistLabel, elapsedTimerLabel, remainingTimeLabel].forEach { (view) in
            view.textColor = .white
        }
        [previousButton, playPauseButton, nextButton].forEach { (view) in
            view.tintColor = .white
        }
        [albumName, albumCover, songNameLabel, artistLabel, progressBar, elapsedTimerLabel,
         remainingTimeLabel, controlStack, volumeBar].forEach { (view) in
            addSubview(view)
         }
        setupConstrains()
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            albumName.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            albumName.leadingAnchor.constraint(equalTo: leadingAnchor),
            albumName.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            albumCover.topAnchor.constraint(equalTo: albumName.bottomAnchor, constant: 32),
            albumCover.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            albumCover.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            albumCover.heightAnchor.constraint(equalTo: albumCover.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            songNameLabel.topAnchor.constraint(equalTo: albumCover.bottomAnchor, constant: 18),
            songNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            songNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        ])
        
        NSLayoutConstraint.activate([
            artistLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 10),
            artistLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            artistLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        ])
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10),
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        ])
        
        NSLayoutConstraint.activate([
            elapsedTimerLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10),
            elapsedTimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            remainingTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10),
            remainingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
        ])
        
        NSLayoutConstraint.activate([
            controlStack.topAnchor.constraint(equalTo: remainingTimeLabel.bottomAnchor, constant: 10),
            controlStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            controlStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            volumeBar.topAnchor.constraint(equalTo: controlStack.bottomAnchor, constant: 10),
            volumeBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            volumeBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        ])
    }
    
    private func setupPlayer(song: Song) {
        guard let url = Bundle.main.url(forResource: song.fileName, withExtension: ".mp3") else {
            return
        }
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.0011, target: self,
                                         selector: #selector(updateProgress),
                                         userInfo: nil, repeats: true)
        }
        songNameLabel.text = song.name
        artistLabel.text = song.artist
        albumCover.image = UIImage(named: song.image)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
        setVolume()
    }
    
    func play() {
        progressBar.value = 0.0
        progressBar.maximumValue = Float(player.duration)
        player.play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    func stop() {
        player.stop()
        timer?.invalidate()
        timer = nil
    }
    
    func setVolume() {
        volumeBar.value = currentVolume
        player.volume = volumeBar.value
    }
    
    private func setPlayPauseIcon(isPlaying: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 80)
        playPauseButton.setImage(UIImage(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill",
                                         withConfiguration: config), for: .normal)
    }
    
    private func getFormattedTime (timeInterval: TimeInterval) -> String {
        let minutes = timeInterval / 60
        let seconds = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeFormatter = NumberFormatter()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
        guard let minutesString = timeFormatter.string(from: NSNumber(value: minutes)),
              let secondString = timeFormatter.string(from: NSNumber(value: seconds))
        else {
            return "00:00"
        }
        return "\(minutesString): \(secondString)"
    }
    func setupAirPlayButton() {
        
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = volumeBar.value
        player.volume = value
        currentVolume = value
    }
    
    @objc private func progressScrubbed(_ sender: UISlider) {
        player.currentTime = Float64(sender.value)
    }
    
    @objc private func didTapPrevious(_ sender: UIButton) {
        playingIndex -= 1
        if playingIndex < 0 {
            playingIndex = album.songs.count - 1
        }
        setupPlayer(song: album.songs[playingIndex])
        play()
    }
    
    @objc func didTapPlayPause(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc func updateProgress() {
        progressBar.value = Float(player.currentTime)
        let remainingTime = player.duration - player.currentTime
        remainingTimeLabel.text = getFormattedTime(timeInterval: player.currentTime)
        elapsedTimerLabel.text = getFormattedTime(timeInterval: remainingTime)
    }
    
    @objc private func didTapNext(_ sender: UIButton) {
        playingIndex += 1
        if playingIndex >= album.songs.count {
            playingIndex = 0
        }
        setupPlayer(song: album.songs[playingIndex])
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc private func blueToothSearch() {
        bleManager = BLEManager()
        showAlert()
    }
    
    @objc private func airPlayMode() {
        let rect = CGRect(x: 100, y: 0, width: 0, height: 0)
        let airPlayVolume = MPVolumeView(frame: rect)
        airPlayVolume.showsVolumeSlider = false
        self.addSubview(airPlayVolume)
        for view: UIView in airPlayVolume.subviews {
            if let button = view as? UIButton{
                button.sendActions(for: .touchUpInside)
                break
            }
        }
        airPlayVolume.removeFromSuperview()
    }
    
    func showAlert() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "iPhone", style: .default, handler: { (action) in
            //do airplay stuff that connects to the iPhone
        }))
        ac.addAction(UIAlertAction(title: "MacBook Pro", style: .default, handler: { (action) in
            //do airplay stuff that connects to the MacBook Pro
        }))
        ac.addAction(UIAlertAction(title: "Apple TV 3", style: .default, handler: { (action) in
            //do airplay stuff that connects to the Apple TV 3
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
}

extension MediaPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didTapPlayPause(playPauseButton)
    }
}
