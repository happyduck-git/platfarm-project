//
//  CollectionViewCell.swift
//  platfarm-project
//
//  Created by HappyDuck on 2022/09/17.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    
    //MARK: - Variables
    var linkedViewController: ViewController?

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.white
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.widthAnchor.constraint(equalToConstant: 150).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let deleteBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = Colors.pinkShadow
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //action
        button.addTarget(self, action: #selector(deleteBtnInCellPressed), for: .touchUpInside)
        
       return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(numberLabel)
        contentView.addSubview(deleteBtn)
        contentView.backgroundColor = Colors.pinkShadow
        contentView.layer.cornerRadius = contentView.frame.height/5
        
        layout()
        
    }
    
    func commonInit(number: Int) {
        numberLabel.text = String(number)
        cellCreateAnimation()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        numberLabel.text = nil

    }
    
    //MARK: - Layout
    private func layout() {
        numberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        deleteBtn.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 10).isActive = true
        deleteBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
    }
    
    //MARK: - Button action
    @objc func deleteBtnInCellPressed() {
        let num = Int(numberLabel.text!)

        linkedViewController?.removeDataAt(index: num!)
        
    }
    
    //MARK: - Animation
    private func cellCreateAnimation() {
        UIView.animate(withDuration: 0.7, delay: 0) {
            self.contentView.backgroundColor = Colors.cellColor
            self.deleteBtn.backgroundColor = Colors.deleteColor
        }
    }
  
}
