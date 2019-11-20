import UIKit

class ContentCollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var containerItem: SPTAppRemoteContentItem? = nil {
        didSet {
            needsReload = true
        }
    }
    var contentItems = [SPTAppRemoteContentItem]()
    var needsReload = true
    
    var appRemote: SPTAppRemote {
        get {
            return AppDelegate.sharedInstance.appRemote
        }
    }

    func loadContent() {
        guard needsReload == true else {
            return
        }

        if let container = containerItem {
            appRemote.contentAPI?.fetchChildren(of: container) { (items, error) in
                if let contentItems = items as? [SPTAppRemoteContentItem] {
                    self.contentItems = contentItems
                }
                self.collectionView?.reloadData()
            }
        } else {
            appRemote.contentAPI?.fetchRootContentItems(forType: SPTAppRemoteContentTypeDefault) { (items, error) in
                if let contentItems = items as? [SPTAppRemoteContentItem] {
                    self.contentItems = contentItems
                }
                self.collectionView?.reloadData()
            }
        }

        needsReload = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationItem.title = containerItem?.title ?? "Spotify"
        loadContent()
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentItemCell", for: indexPath) as! ContentItemCell
        let item = contentItems[indexPath.item]

        cell.titleLabel?.text = item.title
        cell.subtitleLabel?.text = item.subtitle

        cell.imageView.image = nil
        appRemote.imageAPI?.fetchImage(forItem: item, with: scaledSizeForCell(cell)) { (image, error) in
            guard let image = image as? UIImage, error == nil,
                  let cell = collectionView.cellForItem(at: indexPath) as? ContentItemCell else { return }
            cell.imageView?.image = image
        }

        return cell
    }

    private func scaledSizeForCell(_ cell: UICollectionViewCell) -> CGSize {
        let scale = UIScreen.main.scale
        let size = cell.frame.size
        return CGSize(width: size.width * scale, height: size.height * scale)
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2.0
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = restorationIdentifier,
            let newVc = storyboard?.instantiateViewController(withIdentifier: id) as? ContentCollectionViewController else {
            return
        }

        let selectedItem = contentItems[indexPath.item]

        if selectedItem.isContainer {
            newVc.containerItem = selectedItem

            navigationController?.pushViewController(newVc, animated: true)
        } else {
            appRemote.playerAPI?.play(selectedItem, callback: nil)
        }
    }
}
