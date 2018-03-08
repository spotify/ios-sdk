import UIKit
import StoreKit

class ViewController: UIViewController,
                      SPTAppRemotePlayerStateDelegate,
                      SPTAppRemoteUserAPIDelegate,
                      SKStoreProductViewControllerDelegate {

    fileprivate let playURI = "spotify:album:5uMfshtC2Jwqui0NUyUYIL"
    fileprivate let trackIdentifier = "spotify:track:32ftxJzxMPgUFCM6Km9WTS"
    fileprivate let name = "Now Playing View"

    // MARK: - Lifecycle

    fileprivate var connectionIndicatorView = ConnectionStatusIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: connectionIndicatorView)
        connectionIndicatorView.frame = CGRect(origin: CGPoint(), size: CGSize(width: 20,height: 20))

        playPauseButton.setTitle("", for: UIControlState.normal);
        playPauseButton.setImage(PlaybackButtonGraphics.playButtonImage(), for: UIControlState.normal)
        playPauseButton.setImage(PlaybackButtonGraphics.playButtonImage(), for: UIControlState.highlighted)

        nextButton.setTitle("", for: UIControlState.normal)
        nextButton.setImage(PlaybackButtonGraphics.nextButtonImage(), for: UIControlState.normal)
        nextButton.setImage(PlaybackButtonGraphics.nextButtonImage(), for: UIControlState.highlighted)

        prevButton.setTitle("", for: UIControlState.normal)
        prevButton.setImage(PlaybackButtonGraphics.previousButtonImage(), for: UIControlState.normal)
        prevButton.setImage(PlaybackButtonGraphics.previousButtonImage(), for: UIControlState.highlighted)
    }

    // MARK: - View

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var prevButton: UIButton!

    fileprivate func updateViewWithPlayerState(_ playerState: SPTAppRemotePlayerState) {
        updatePlayPauseButtonState(playerState.isPaused)
        updateRepeatModeLabel(playerState.playbackOptions.repeatMode)
        updateShuffleLabel(playerState.playbackOptions.isShuffling)
        trackNameLabel.text = playerState.track.name + " - " + playerState.track.artist.name
        fetchAlbumArtForTrack(playerState.track) { (image) -> Void in
            self.updateAlbumArtWithImage(image)
        }
        updateViewWithRestrictions(playerState.playbackRestrictions)
    }

    fileprivate func updateViewWithRestrictions(_ restrictions: SPTAppRemotePlaybackRestrictions) {
        nextButton.isEnabled = restrictions.canSkipNext
        prevButton.isEnabled = restrictions.canSkipPrevious
        toggleShuffleButton.isEnabled = restrictions.canToggleShuffle
        toggleRepeatModeButton.isEnabled = restrictions.canRepeatContext || restrictions.canRepeatTrack
    }

    fileprivate func encodeStringAsUrlParameter(_ value: String) -> String {
        let escapedString = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return escapedString!
    }

    fileprivate func enableInterface(_ enabled: Bool = true) {
        buttons.forEach { (button) -> () in
            button.isEnabled = enabled
        }

        if (!enabled) {
            albumArtImageView.image = nil
            updatePlayPauseButtonState(true);
        }
    }

    // MARK: Player Control

    @IBOutlet weak var playPauseButton: UIButton!

    @IBAction func didPressPlayPauseButton(_ sender: AnyObject) {
        if !(appRemote.isConnected) {
            if (!appRemote.authorizeAndPlayURI(playURI)) {
                // The Spotify app is not installed, present the user with an App Store page
                showAppStoreInstall()
            }
        } else if playerState == nil || playerState!.isPaused {
            startPlayback()
        } else {
            pausePlayback()
        }
    }

    @IBAction func didPressPreviousButton(_ sender: AnyObject) {
        skipPrevious()
    }

    @IBAction func didPressNextButton(_ sender: AnyObject) {
        skipNext()
    }

    @IBAction func didPressPlayTrackButton(_ sender: AnyObject) {
        playTrack()
    }

    @IBAction func didPressEnqueueTrackButton(_ sender: AnyObject) {
        enqueueTrack()
    }

    fileprivate func updatePlayPauseButtonState(_ paused: Bool) {
        let playPauseButtonImage = paused ? PlaybackButtonGraphics.playButtonImage() : PlaybackButtonGraphics.pauseButtonImage()
        playPauseButton.setImage(playPauseButtonImage, for: UIControlState())
        playPauseButton.setImage(playPauseButtonImage, for: .highlighted)
    }

    // MARK: Player State

    @IBOutlet weak var playerStateSubscriptionButton: UIButton!

    @IBAction func didPressGetPlayerStateButton(_ sender: AnyObject) {
        getPlayerState()
    }

    @IBAction func didPressPlayerStateSubscriptionButton(_ sender: AnyObject) {
        if (subscribedToPlayerState) {
            unsubscribeFromPlayerState()
        } else {
            subscribeToPlayerState()
        }
    }

    fileprivate func updatePlayerStateSubscriptionButtonState() {
        let playerStateSubscriptionButtonTitle = subscribedToPlayerState ? "Unsubscribe" : "Subscribe"
        playerStateSubscriptionButton.setTitle(playerStateSubscriptionButtonTitle, for: UIControlState())
    }

    // MARK: Capabilities

    @IBOutlet weak var onDemandCapabilitiesLabel: UILabel!
    @IBOutlet weak var capabilitiesSubscriptionButton: UIButton!

    @IBAction func didPressGetCapabilitiesButton(_ sender: AnyObject) {
        fetchUserCapabilities()
    }

    @IBAction func didPressCapabilitiesSubscriptionButton(_ sender: AnyObject) {
        if (subscribedToCapabilities) {
            unsubscribeFromCapailityChanges()
        } else {
            subscribeToCapabilityChanges()
        }
    }

    fileprivate func updateViewWithCapabilities(_ capabilities: SPTAppRemoteUserCapabilities) {
        onDemandCapabilitiesLabel.text = "Can play on demand: " + (capabilities.canPlayOnDemand ? "Yes" : "No")
    }

    fileprivate func updateCapabilitiesSubscriptionButtonState() {
        let capabilitiesSubscriptionButtonTitle = subscribedToCapabilities ? "Unsubscribe" : "Subscribe"
        capabilitiesSubscriptionButton.setTitle(capabilitiesSubscriptionButtonTitle, for: UIControlState())
    }

    // MARK: Shuffle Button

    @IBOutlet weak var toggleShuffleButton: UIButton!
    @IBOutlet weak var shuffleModeLabel: UILabel!

    @IBAction func didPressToggleShuffleButton(_ sender: AnyObject) {
        toggleShuffle()
    }
    fileprivate func updateShuffleLabel(_ isShuffling: Bool) {
        shuffleModeLabel.text = "Shuffle mode: " + (isShuffling ? "On" : "Off")
    }

    // MARK: Repeat Mode Button

    @IBOutlet weak var toggleRepeatModeButton: UIButton!
    @IBOutlet weak var repeatModeLabel: UILabel!
    @IBAction func didPressToggleRepeatModeButton(_ sender: AnyObject) {
        toggleRepeatMode()
    }

    fileprivate func updateRepeatModeLabel(_ repeatMode: SPTAppRemotePlaybackOptionsRepeatMode) {
        repeatModeLabel.text = "Repeat mode: " + {
            switch repeatMode {
                case .off: return "Off"
                case .track: return "Track"
                case .context: return "Context"
            }
        }()
    }

    // MARK: Album Art

    @IBOutlet weak var albumArtImageView: UIImageView!

    fileprivate func updateAlbumArtWithImage(_ image: UIImage) {
        self.albumArtImageView.image = image
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        self.albumArtImageView.layer.add(transition, forKey: "transition")
    }
    
    

    fileprivate var playerState: SPTAppRemotePlayerState?
    fileprivate var subscribedToPlayerState: Bool = false
    
    
    var defaultCallback: SPTAppRemoteCallback {
        get {
            return {[unowned self] _, error in
                if let error = error {
                    self.displayError(error as NSError)
                }
            }
        }
    }
    
    fileprivate func displayError(_ error: NSError?) {
        if let error = error {
            presentAlert(title: "Error", message: error.description)
        }
    }

    fileprivate func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: StoreKit

    fileprivate func showAppStoreInstall() {
        if TARGET_OS_SIMULATOR != 0 {
            presentAlert(title: "Simulator In Use", message: "The App Store is not available in the iOS simulator, please test this feature on a physical device.")
        } else {
            let loadingView = UIActivityIndicatorView(frame: view.bounds)
            view.addSubview(loadingView)
            loadingView.startAnimating()
            loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            let storeProductViewController = SKStoreProductViewController()
            storeProductViewController.delegate = self
            storeProductViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: SPTAppRemote.spotifyItunesItemIdentifier()], completionBlock: { (success, error) in
                loadingView.removeFromSuperview()
                if let error = error {
                    self.presentAlert(
                        title: "Error accessing App Store",
                        message: error.localizedDescription)
                } else {
                    self.present(storeProductViewController, animated: true, completion: nil)
                }
            })
        }
    }

    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    var appRemote: SPTAppRemote {
        get {
            return AppDelegate.sharedInstance.appRemote
        }
    }

    fileprivate func skipNext() {
        appRemote.playerAPI?.skip(toNext: defaultCallback)
    }

    fileprivate func skipPrevious() {
        appRemote.playerAPI?.skip(toPrevious: defaultCallback)
    }

    fileprivate func startPlayback() {
        appRemote.playerAPI?.resume(defaultCallback)
    }

    fileprivate func pausePlayback() {
        appRemote.playerAPI?.pause(defaultCallback)
    }
    
    fileprivate func playTrack() {
        appRemote.playerAPI?.play(trackIdentifier, callback: defaultCallback)
    }

    fileprivate func enqueueTrack() {
        appRemote.playerAPI?.enqueueTrackUri(trackIdentifier, callback: defaultCallback)
    }

    fileprivate func toggleShuffle() {
        guard let playerState = playerState else { return }
        appRemote.playerAPI?.setShuffle(!playerState.playbackOptions.isShuffling, callback: defaultCallback)
    }

    fileprivate func getPlayerState() {
        appRemote.playerAPI?.getPlayerState { (result, error) -> Void in
            guard error == nil else { return }

            let playerState = result as! SPTAppRemotePlayerState
            self.updateViewWithPlayerState(playerState)
        }
    }

    fileprivate func playTrackWithIdentifier(_ identifier: String) {
        appRemote.playerAPI?.play(identifier, callback: defaultCallback)
    }

    fileprivate func subscribeToPlayerState() {
        guard (!subscribedToPlayerState) else { return }
        appRemote.playerAPI!.delegate = self
        appRemote.playerAPI?.subscribe { (_, error) -> Void in
            guard error == nil else { return }
            self.subscribedToPlayerState = true
            self.updatePlayerStateSubscriptionButtonState()
        }
    }

    fileprivate func unsubscribeFromPlayerState() {
        guard (subscribedToPlayerState) else { return }
        appRemote.playerAPI?.unsubscribe { (_, error) -> Void in
            guard error == nil else { return }
            self.subscribedToPlayerState = false
            self.updatePlayerStateSubscriptionButtonState()
        }
    }

    fileprivate func toggleRepeatMode() {
        guard let playerState = playerState else { return }
        let repeatMode: SPTAppRemotePlaybackOptionsRepeatMode = {
            switch playerState.playbackOptions.repeatMode {
                case .off: return SPTAppRemotePlaybackOptionsRepeatMode.track
                case .track: return SPTAppRemotePlaybackOptionsRepeatMode.context
                case .context: return SPTAppRemotePlaybackOptionsRepeatMode.off
            }
        }()

        appRemote.playerAPI?.setRepeatMode(repeatMode, callback: defaultCallback)
    }

    // MARK: - Image API

    fileprivate func fetchAlbumArtForTrack(_ track: SPTAppRemoteTrack, callback: @escaping (UIImage) -> Void ) {
        appRemote.imageAPI?.fetchImage(forItem: track, with:CGSize(width: 1000, height: 1000), callback: { (image, error) -> Void in
            guard error == nil else { return }

            let image = image as! UIImage
            callback(image)
        })
    }

    // MARK: - User API
    fileprivate var subscribedToCapabilities: Bool = false

    fileprivate func fetchUserCapabilities() {
        appRemote.userAPI?.fetchCapabilities(callback: { (capabilities, error) in
            guard error == nil else { return }

            let capabilities = capabilities as! SPTAppRemoteUserCapabilities
            self.updateViewWithCapabilities(capabilities)
        })
    }

    fileprivate func subscribeToCapabilityChanges() {
        guard (!subscribedToCapabilities) else { return }
        appRemote.userAPI!.delegate = self
        appRemote.userAPI?.subscribe(toCapabilityChanges: { (success, error) in
            guard error == nil else { return }

            self.subscribedToCapabilities = true
            self.updateCapabilitiesSubscriptionButtonState()
        })
    }

    fileprivate func unsubscribeFromCapailityChanges() {
        guard (subscribedToCapabilities) else { return }
        AppDelegate.sharedInstance.appRemote.userAPI?.unsubscribe(toCapabilityChanges: { (success, error) in
            guard error == nil else { return }

            self.subscribedToCapabilities = false
            self.updateCapabilitiesSubscriptionButtonState()
        })
    }

    // MARK: - <SPTAppRemotePlayerStateDelegate>

    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        self.playerState = playerState
        updateViewWithPlayerState(playerState)
    }

    // MARK: - <SPTAppRemoteUserAPIDelegate>

    func userAPI(_ userAPI: SPTAppRemoteUserAPI, didReceive capabilities: SPTAppRemoteUserCapabilities) {
        updateViewWithCapabilities(capabilities)
    }

    func showError(_ errorDescription: String) {
        let alert = UIAlertController(title: "Error!", message: errorDescription, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func appRemoteConnecting() {
        connectionIndicatorView.state = .connecting
    }

    func appRemoteConnected() {
        connectionIndicatorView.state = .connected
        subscribeToPlayerState()
        subscribeToCapabilityChanges()
        getPlayerState()

        enableInterface(true)
    }

    func appRemoteDisconnect() {
        connectionIndicatorView.state = .disconnected
        self.subscribedToPlayerState = false
        self.subscribedToCapabilities = false
        enableInterface(false)
    }
}
