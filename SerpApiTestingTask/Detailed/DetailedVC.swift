
import UIKit

protocol DetailedViewProtocol: AnyObject {
    func display(title: String)
    func setup(image: UIImage)
}

class DetailedVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    private let activity = UIActivityIndicatorView(style: .large)
    
    var presenter: DetailedPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter?.showDetails()
    }
    
}

// MARK: SetupViewProtocol
extension DetailedVC {
    
    func setupViews() {
        setupSelf()
        setupNavigationController()
        setupImageView()
        setupLinkButton()
    }
    
    func setupSelf() {
        view.backgroundColor = .white
    }
    
    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        changeImageViewHeight()
        setupActivityIndicator()
    }
    
    func setupLinkButton() {
        linkButton.setTitle("Move to source", for: .normal)
        linkButton.addTarget(self, action: #selector(moveToSource), for: .touchUpInside)
        linkButton.layer.cornerRadius = 16
        linkButton.setTitleColor(.white, for: .normal)
        linkButton.backgroundColor = .systemMint
        
    }
    
    func setupActivityIndicator() {
        activity.color = .systemMint
        imageView.addSubview(activity)
        activity.center = imageView.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
    }
    
    
    func setupNavigationController() {
       
        
    }
    
    @IBAction func moveToSource(_ sender: UIButton) {
        presenter?.linkButtonPressed()
    }
    
}

// MARK: DetailedViewInputProtocol
extension DetailedVC: DetailedViewProtocol {
    
    func display(title: String) {
        titleLabel.text = title
    }
    
    func changeImageViewHeight() {
        let width = view.frame.width
        if let newHeight = presenter?.calculateImageHeight(for: width) {
            imageViewHeight.constant = newHeight
            imageView.layoutIfNeeded()
        }
    }
    
    func setup(image: UIImage) {
        activity.stopAnimating()
        imageView.image = image
    }
    
}
