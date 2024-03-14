
import UIKit

protocol DetailedViewProtocol: AnyObject {
    func display(title: String)
    func changeImageViewHeight()
    func setup(image: UIImage)
}

class DetailedVC: UIViewController {
    
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    private var stackView = UIStackView()
    private var titleLabel = UILabel()
    private var imageView = UIImageView()
    private var linkButton = UIButton()
    private let activity = UIActivityIndicatorView(style: .large)
    private var imageViewHeight : NSLayoutConstraint!
    
    var presenter: DetailedPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.showDetails()
    }
    
    
    @IBAction func moveToSource(_ sender: UIButton) {
        presenter?.linkButtonPressed()
    }
    
}

// MARK: SetupViewProtocol
extension DetailedVC : SetupViewProtocol {
    
    func setupViews() {
        setupSelf()
        setupTitleLabel()
        setupStackView()
        setupImageView()
        setupLinkButton()
    }
    
    func setupSelf() {
        view.backgroundColor = .white
    }
    
    func setupStackView() {
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 24
    }
    
    func setupTitleLabel() {
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.numberOfLines = 0
    }
        
    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
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
        activity.hidesWhenStopped = true
        activity.startAnimating()
    }
    
    func addViews() {
        view.addSubview(scrollView)
        view.addSubview(activity)
        scrollView.addSubview(containerView)
        containerView.addSubview(stackView)
        [titleLabel, imageView, linkButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
    }
    
    func setupConstraints() {
        [scrollView, containerView, stackView, 
         titleLabel, imageView, linkButton, activity].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let margins = view.layoutMarginsGuide
        imageViewHeight = imageView.heightAnchor.constraint(equalToConstant: 100)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: margins.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: margins.widthAnchor),
            imageViewHeight,
            activity.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            linkButton.heightAnchor.constraint(equalToConstant: 55)
        ])
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
            stackView.layoutIfNeeded()
        }
    }
    
    func setup(image: UIImage) {
        activity.stopAnimating()
        imageView.image = image
    }
    
}
