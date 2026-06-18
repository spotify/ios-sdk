import UIKit

class ViewController: UIViewController {

    // MARK: - UI Elements

    private let logoImage = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let playButton = UIButton(type: .system)
    private let stopButton = UIButton(type: .system)
    private let statusView = UIView()
    private let statusLabel = UILabel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
    }

    // MARK: - Setup UI

    private func setupUI() {
        view.backgroundColor = UIColor.black

        // Logo
        logoImage.image = UIImage(systemName: "music.note")
        logoImage.tintColor = .systemGreen
        logoImage.contentMode = .scaleAspectFit
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)

        // Title
        titleLabel.text = "Spotify Player"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Subtitle
        subtitleLabel.text = "Swift iOS Demo Interface"
        subtitleLabel.textColor = .lightGray
        subtitleLabel.font = UIFont.systemFont(ofSize: 18)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)

        // Play Button
        playButton.setTitle("▶ Play", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.backgroundColor = .systemGreen
        playButton.layer.cornerRadius = 18
        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playMusic), for: .touchUpInside)
        view.addSubview(playButton)

        // Stop Button
        stopButton.setTitle("■ Stop", for: .normal)
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.backgroundColor = .systemRed
        stopButton.layer.cornerRadius = 18
        stopButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.addTarget(self, action: #selector(stopMusic), for: .touchUpInside)
        view.addSubview(stopButton)

        // Status View
        statusView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        statusView.layer.cornerRadius = 16
        statusView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusView)

        // Status Label
        statusLabel.text = "Status: Waiting"
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 18)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusView.addSubview(statusLabel)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImage.widthAnchor.constraint(equalToConstant: 100),
            logoImage.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 20),

            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),

            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            playButton.widthAnchor.constraint(equalToConstant: 220),
            playButton.heightAnchor.constraint(equalToConstant: 55),

            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            stopButton.widthAnchor.constraint(equalToConstant: 220),
            stopButton.heightAnchor.constraint(equalToConstant: 55),

            statusView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusView.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 40),
            statusView.widthAnchor.constraint(equalToConstant: 280),
            statusView.heightAnchor.constraint(equalToConstant: 70),

            statusLabel.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func playMusic() {
        statusLabel.text = "Status: Playing Music"

        let alert = UIAlertController(
            title: "Music Started",
            message: "The play button was pressed successfully.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }

    @objc private func stopMusic() {
        statusLabel.text = "Status: Music Stopped"

        let alert = UIAlertController(
            title: "Music Stopped",
            message: "Playback has been stopped.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Close", style: .cancel))

        present(alert, animated: true)
    }
}
