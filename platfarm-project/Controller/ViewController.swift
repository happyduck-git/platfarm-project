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
    //data - userdefaults 사용
    var dataArr = Array<Int>()
    private var userDefault = UserDefaults.standard
    private let userDefaultCellData = "CellDataArray"
    
    //UICollectionView 구성 요소
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
    
    //add & delete 버튼을 담을 stackView
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
        
        //cell과 연결된 viewController를 self로 지정
        cell.linkedViewController = self
        cell.commonInit(number: dataArr[indexPath.row])
        //contentView를 180도 뒤집었으므로 cell은 원래대로 나오도록 회전
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

        return cell
    }
    
    

//MARK: - Data related functions
    
    func getDataArr() -> [Int] {
        return dataArr
    }
    
    //dataArr과 userDefault에 데이터 저장
    func addDataToArr() {
        if(dataArr.count != 0) {
            dataArr.append(dataArr[dataArr.endIndex - 1] + 1)
        } else {
            dataArr.append(0)
        }
        userDefault.set(dataArr, forKey: userDefaultCellData)
        dispatchQueue()
    }
    
    //dataArr과 userDefault에서 데이터 삭제
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

    //특정 셀 데이터 삭제
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
    
    //add & delete 버튼 layout
    private func stackViewLayout() {
        buttonStackView.addArrangedSubview(addBtn)
        buttonStackView.addArrangedSubview(deleteBtn)
        buttonStackView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //background color 그라데이션
    private func gradientBackground() {
        layer.frame = view.bounds
        layer.colors = [Colors.mainPink.cgColor, Colors.white.cgColor]
        layer.startPoint = CGPoint(x:0, y:0)
        layer.endPoint = CGPoint(x: 1,y: 1)
        view.layer.addSublayer(layer)
    }
    

    //collectionView 생성
    private func collectionViewInit() {
    
        //기본적인 layout인 FlowLayout사용
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.size.width/3, height: view.frame.size.height/6)
        layout.minimumInteritemSpacing = 150

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        //사용할 collectionViewCell 등록
        collectionView?.register(CollectionViewCell.self,
                                                forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
    }
    
    //colletionView의 레이아웃과 관계된 설정
    private func collectionViewLayout() {
        
        collectionView?.backgroundColor? = Colors.transparent
        //collectionView를 거꾸로 돌려서 셀이 아래부터 추가되는 것처럼 효과를 줌
        collectionView?.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        collectionView?.showsVerticalScrollIndicator = false
        
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
    
    //reloadData를 위한 method
    private func dispatchQueue() {
    
        DispatchQueue.main.async {
         
            self.collectionView?.reloadData()
            self.scrollToLastCell()
        }
    }
    
    //가장 최근에 추가된 셀로 자동 scroll 하기 위한 method
    private func scrollToLastCell() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.getDataArr().count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}

