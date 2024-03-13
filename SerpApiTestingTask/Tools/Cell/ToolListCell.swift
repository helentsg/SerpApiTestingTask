//
//  ToolListCell.swift
//  VIPERTest
//
//  Created by Elena Lucher on 09.03.2024.
//

import UIKit

class ToolListCell: UITableViewCell {
    
    static var reuseID = String(describing: ToolListCell.self)
    
    private var stackView = UIStackView()
    private var titleLabel = UILabel()
    private var markImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ?
            UIFont.systemFont(ofSize: 16, weight: .semibold) :
            UIFont.systemFont(ofSize: 16, weight: .regular)
            markImageView.isHidden = !isSelected
        }
    }
    
    // MARK: Public methods
    
    func configure(for data: (model: GoogleModel, isSelected: Bool)) {
        titleLabel.text = data.model.name
        self.isSelected = data.isSelected
    }
    
}

// MARK: SetupViewProtocol
extension ToolListCell {
    
    func setupView() {
        setupViews()
        addViews()
        setupConstraints()
    }
    
    func setupViews() {
        setupSelf()
        setupStackView()
        setupTitleLabel()
        setupMarkImageView()
    }
    
    func setupSelf() {
        selectionStyle = .none
    }
    
    func setupStackView() {
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 16
    }
    
    func setupTitleLabel() {
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.numberOfLines = 0
    }
    
    func setupMarkImageView() {
        markImageView.image = UIImage(systemName: "checkmark")
        markImageView.tintColor = .systemMint
        markImageView.isHidden = false
    }
    
    func addViews() {
        addSubview(stackView)
        [titleLabel, markImageView].forEach {
            stackView.addArrangedSubview($0)
        }
        
    }
    
    func setupConstraints() {
        [stackView, titleLabel, markImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            markImageView.heightAnchor.constraint(equalToConstant: 30),
            markImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
}


