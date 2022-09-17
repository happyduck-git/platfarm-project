//
//  ViewController.swift
//  platfarm-project
//
//  Created by HappyDuck on 2022/09/17.
//

import UIKit

class ViewController: UIViewController,
                      UICollectionViewDelegate,
                      UICollectionViewDataSource {
    
    //MARK: - Variables
    //data
    var dataArr = Array<Int>()
    private var userDefault = UserDefaults.standard
    private let userDefaultCellData = "CellDataArray"
    
    private var collectionView: UICollectionView?
    private let layer = CAGradientLayer()
    private var alert: UIAlertController?
    private var alertAction: UIAlertAction?
    
    private let addBtn: UIButton = {
        
        let button = UIButton()
        
        button.backgroundColor = Colors.addColor
        button.setTitle("Add", for: .normal)
    
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.borderColor = Colors.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
    
        //add action
        button.addTarget(self, action: #selector(addBtnPressed), for: .touchUpInside)

        
        return button
    }()
    
    private let deleteBtn: UIButton = {
        
        let button = UIButton()
        
        button.backgroundColor = Colors.deleteColor
        button.setTitle("Delete", for: .normal)
    
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.borderColor = Colors.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        
        //add action
        button.addTarget(self, action: #selector(deleteBtnPressed), for: .touchUpInside)
        
    
        return button
    }()
    
    private let buttonStackView: UIStackView = {
       
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = 10.0
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    }()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        gradientBackground()
        
        //button stack view
        view.addSubview(buttonStackView)
        stackViewLayout()
        
        //collection view
        collectionViewInit()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        view.addSubview(collectionView!)
        collectionViewLayout()
        
        //userdefaults에 저장된 데이터를 화면에 보여주기
        if let items = userDefault.array(forKey: userDefaultCellData) as? [Int] {
            dataArr = items
        }
        
    }
    
    
    //MARK: - CollectionView DataSource functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return getDataArr().count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            fatalError()
        }
        
        cell.linkedViewController = self
        cell.commonInit(number: dataArr[indexPath.row])
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

        return cell
    }
    
    

//MARK: - Data related functions
    
    func getDataArr() -> [Int] {
        return dataArr
    }
    
    func addDataToArr() {
        if(dataArr.count != 0) {
            dataArr.append(dataArr[dataArr.endIndex - 1] + 1)
        } else {
            dataArr.append(0)
        }
        userDefault.set(dataArr, forKey: userDefaultCellData)
        dispatchQueue()
    }
    
    func deleteDataToArr() {
        
        if(dataArr.count != 0) {
            dataArr.removeLast()
            userDefault.set(dataArr, forKey: userDefaultCellData)
        } else {
            alert = UIAlertController(title: "알림", message: "삭제할 셀이 더 이상 없습니다.", preferredStyle: .alert)
            alertAction = UIAlertAction(title: "확인", style: .default) {
                action in self.dismiss(animated: true)
            }
            alert?.addAction(alertAction!)
            present(alert!, animated: true)
            
        }
        
        dispatchQueue()
    }

    
    func removeLast() {
        dataArr.removeLast()
    }
    
    func removeDataAt(index: Int) {
        
        for i in 0..<dataArr.count {
            if(dataArr[i] == index) {
                dataArr.remove(at: i)
                userDefault.set(dataArr, forKey: userDefaultCellData)
                dispatchQueue()
                break
            }
        }
    }
    
    //MARK: - Layouts
    
    private func stackViewLayout() {
        buttonStackView.addArrangedSubview(addBtn)
        buttonStackView.addArrangedSubview(deleteBtn)
        buttonStackView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func gradientBackground() {
        layer.frame = view.bounds
        layer.colors = [Colors.mainPink.cgColor, Colors.white.cgColor]
        layer.startPoint = CGPoint(x:0, y:0)
        layer.endPoint = CGPoint(x: 1,y: 1)
        view.layer.addSublayer(layer)
    }
    

    private func collectionViewInit() {
              
        let layout = CustomLayout()
        layout.delegate = self

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView?.register(CollectionViewCell.self,
                                                forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
    }
    
    private func collectionViewLayout() {
        
        collectionView?.backgroundColor? = Colors.transparent
        collectionView?.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        collectionView?.showsVerticalScrollIndicator = true
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 10).isActive = true
        collectionView?.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    //MARK: - Button actions
    @objc func addBtnPressed() {
        // cell 추가하기

        addDataToArr()
        
    }
    
    @objc func deleteBtnPressed() {
        // cell 삭제하기

        deleteDataToArr()

    }
    
    
    //MARK: - DispatchQueue
    
    private func dispatchQueue() {
    
        DispatchQueue.main.async {
         
            self.collectionView?.reloadData()
            self.scrollToLastCell()
        }
    }
    
    private func scrollToLastCell() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.getDataArr().count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}

extension ViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, xOffset indexPath: IndexPath) -> CGFloat {
        
        return 120

    }
}

