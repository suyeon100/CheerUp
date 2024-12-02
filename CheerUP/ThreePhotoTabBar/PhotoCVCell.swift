//
//  PhotoCVCell.swift
//  CheerUP
//
//  Created by 박수연 on 12/2/24.
//

import UIKit

class PhotoCVCell: UICollectionViewCell {

    private let imageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
          imageView.clipsToBounds = true
          imageView.translatesAutoresizingMaskIntoConstraints = false
          return imageView
      }()

      override init(frame: CGRect) {
          super.init(frame: frame)
          contentView.addSubview(imageView)
          NSLayoutConstraint.activate([
              imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
              imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
              imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
              imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
          ])
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

      func configure(with photo: Photo) {
          imageView.image = photo.image
      }
}
