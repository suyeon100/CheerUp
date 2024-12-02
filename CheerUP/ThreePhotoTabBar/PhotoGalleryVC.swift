//
//  PhotoGalleryVC.swift
//  CheerUP
//
//  Created by 박수연 on 12/2/24.
//

import UIKit


struct Photo {
    let id: UUID
    let image: UIImage
}

class PhotoGalleryVC: UIViewController {
    
    var photos: [Photo] = []
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.minimumLineSpacing = 10  // 세로 간격
        layout.minimumInteritemSpacing = 10  // 셀 간의 가로 간격
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
     
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCVCell.self, forCellWithReuseIdentifier: "PhotoCVCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        setupConstraints()
        setupNavigationBar()
        loadPhotosFromUserDefaults()
    }
    
    
    //데이터 저장
    func savePhotosUserDefaults() {
        let photoDataArray = photos.map { photo in
                ["id": photo.id.uuidString, "imageData": photo.image.pngData()!]
            }
            UserDefaults.standard.set(photoDataArray, forKey: "savedPhotos")
            print("Photos saved to UserDefaults!")
    }
    
    // UserDefaults에서 메모 불러오기
    func loadPhotosFromUserDefaults() {
        guard let savedData = UserDefaults.standard.array(forKey: "savedPhotos") as? [[String: Any]] else {
            print("No photos found in UserDefaults")
            return
        }
        
        // Data를 Photo 객체로 변환
        photos = savedData.compactMap { dict in
            guard
                let idString = dict["id"] as? String,
                let id = UUID(uuidString: idString),
                let imageData = dict["imageData"] as? Data,
                let image = UIImage(data: imageData)
            else {
                return nil
            }
            return Photo(id: id, image: image)
        }
        collectionView.reloadData()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        
    }
    
    @objc private func addPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true)
    }
}
extension PhotoGalleryVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCVCell", for: indexPath) as! PhotoCVCell
        cell.configure(with: photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("눌렸다.")
    }
   
}
extension PhotoGalleryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            let newPhoto = Photo(id: UUID(), image: selectedImage)
            photos.append(newPhoto)
            
            savePhotosUserDefaults()
            collectionView.reloadData()
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
