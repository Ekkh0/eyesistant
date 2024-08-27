//
//  SheetViewController.swift
//  ColorPicker
//
//  Created by Jennifer Luvindi on 20/08/24.
//

import UIKit

struct ColorModel: Codable{
    let color: String
    let rgb: String
    var description: String
    var colorName: String
    var isFavorite: Bool
    
    init(color: String, rgb: String, description: String, colorName: String, isFavorite: Bool) {
        self.color = color
        self.rgb = rgb
        self.description = description
        self.colorName = colorName
        self.isFavorite = isFavorite
    }
}

class SheetViewController: UIViewController {
    private let myCollectionViewFlowLayout = MyCollectionViewFlowLayout()
    private var centerCell: MyCollectionViewCell?
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: myCollectionViewFlowLayout)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        return cv
    }()
    
    private var selectedColor: ColorModel? {
        didSet {
            updateDescriptionLabel()
            updateColorNameTitleLabel()
        }
    }
    
    private func updateColorNameTitleLabel() {
        guard let selectedColor = selectedColor else {
            hexLabel.text = nil
            return
        }
    }
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Personal Color"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.sizeToFit()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    private lazy var xButton: UIImageView = {
        let xButton = UIImageView()
        xButton.contentMode = .scaleAspectFit
        
        if let image = UIImage(systemName: "x.circle.fill") {
            let config = UIImage.SymbolConfiguration(hierarchicalColor: .gray)
            xButton.image = image.applyingSymbolConfiguration(config)
        }
        
        xButton.translatesAutoresizingMaskIntoConstraints = false
        
        xButton.isUserInteractionEnabled = true
        
        return xButton
    }()
    
    private let colorDescriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dividerBottom: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .lightGray
        return divider
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "COLOR DESCRIPTION"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rgbLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectedIndexPath: IndexPath?
    var suggestedColor: [UIColor] = []
    var suggestedColorDescription: [String] = []
    var suggestedColorName: [String] = []
    var colors: [ColorModel] = []
    var onColorSelected: ((UIColor) -> Void)?
    var centerColorName: String = ""
    var centerColorDescription: String = ""
    var detentState: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateColors()
        
        view.backgroundColor = UIColor.systemGray5
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 35),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        view.addSubview(xButton)
        xButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(xButtonTapped(tapGesture:)))
        xButton.addGestureRecognizer(tapGesture)
        NSLayoutConstraint.activate([
            xButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            xButton.heightAnchor.constraint(equalToConstant: 30),
            xButton.widthAnchor.constraint(equalToConstant: 30),
            xButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: xButton.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        // Set the initial layout to horizontal
        myCollectionViewFlowLayout.updateLayoutForOtherDetents()
        
        view.addSubview(dividerBottom)
        
        colorDescriptionView.isHidden = true
        descriptionTitleLabel.isHidden = true
        nameLabel.isHidden = true
        hexLabel.isHidden = true
        rgbLabel.isHidden = true
        colorDescriptionLabel.isHidden = true
        dividerBottom.isHidden = true
        
        setupColorDescriptionView()
        
        updateDescriptionLabel()
        
        myCollectionViewFlowLayout.updateLayoutForOtherDetents()
    }
    
    private func updateDescriptionLabel() {
        guard let selectedColor = selectedColor else {
            nameLabel.text = "No Color Selected"
            hexLabel.text = nil
            colorDescriptionLabel.text = "Please select a color from the collection."
            return
        }
        nameLabel.text = selectedColor.colorName
        hexLabel.text = "HEX: \(selectedColor.color) | RGB: \(selectedColor.rgb)"
        colorDescriptionLabel.text = selectedColor.description
    }
    
    private func setupColorDescriptionView() {
        view.addSubview(colorDescriptionView)
        colorDescriptionView.addSubview(descriptionTitleLabel)
        colorDescriptionView.addSubview(nameLabel)
        colorDescriptionView.addSubview(hexLabel)
        colorDescriptionView.addSubview(rgbLabel)
        colorDescriptionView.addSubview(colorDescriptionLabel)
    }
    
    func populateColors(){
        if let data = UserDefaults.standard.data(forKey: "personalColor"){
            do {
                let decoder = JSONDecoder()
                colors = try decoder.decode([ColorModel].self, from: data)
            } catch {
                // Fallback
            }
        }else{
            for (idx, _) in suggestedColor.enumerated(){
                colors.append(ColorModel.init(color: hexStringFromColor(color: suggestedColor[idx]), rgb: rgbStringFromColor(color: suggestedColor[idx]), description: suggestedColorDescription[idx], colorName: suggestedColorName[idx], isFavorite: false))
            }
        }
    }
    
    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
     }
    
    func rgbStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let rgbString = String(format: "(%d, %d, %d)", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return rgbString
     }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        
        let centerPoint = CGPoint(
            x: self.collectionView.frame.size.width / 2 + scrollView.contentOffset.x,
            y: self.collectionView.frame.size.height / 2
        )
        
        if let indexPath = self.collectionView.indexPathForItem(at: centerPoint) {
            if let previousCenterCell = self.centerCell, previousCenterCell != collectionView.cellForItem(at: indexPath) {
                previousCenterCell.transformToDefault()
            }
            self.centerCell = (self.collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell)
            
            self.centerCell?.transformToLarge()
            onColorSelected!((centerCell?.backgroundColor)!)
            titleLabel.text = detentState == 0 ? colors.first(where: {$0.color == hexStringFromColor(color: (centerCell?.backgroundColor)!)})!.colorName : "Personal Colors"
        }
    }
    
    @objc private func xButtonTapped(tapGesture: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let cell = gesture.view as? MyCollectionViewCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        // Toggle isFavorite for the selected color
        colors[indexPath.row].isFavorite.toggle()
        
        // Update the cell's appearance
        cell.toggleFavorite()
        
        do {
            let colors = colors
            let encoder = JSONEncoder()
            let data = try encoder.encode(colors)
            UserDefaults.standard.set(data, forKey: "personalColor")
        } catch {
            print("Encoding error!")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let layoutMargins: CGFloat = self.collectionView.layoutMargins.left + self.collectionView.layoutMargins.right
        let sideInset = (self.view.frame.width / 2) - layoutMargins
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        centerInitialItem()
        
        sheetPresentationController?.delegate = self
    }
    
    private func centerInitialItem() {
        let indexPath = IndexPath(item: 0, section: 0)
        if let attributes = collectionView.layoutAttributesForItem(at: indexPath) {
            let centerX = attributes.center.x - collectionView.bounds.size.width / 2
            let offsetX = max(centerX, -collectionView.contentInset.left)
            collectionView.setContentOffset(CGPoint(x: offsetX, y: collectionView.contentOffset.y), animated: false)
        }
    }
    
}

final class MyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var shouldSnapToCells: Bool = true
    
    override func prepare() {
        super.prepare()
        
    }
    
    func updateLayoutForLargeDetent() {
        scrollDirection = .vertical
        itemSize = CGSize(width: 80, height: 80)
        minimumInteritemSpacing = 8
        minimumLineSpacing = 8
    }
    
    func updateLayoutForOtherDetents() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: 80, height: 80)
        minimumInteritemSpacing = 18
        minimumLineSpacing = 18
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard shouldSnapToCells else {
            return proposedContentOffset // No snapping when shouldSnapToCells is false
        }
        // Calculate the proposed offset based on the scroll velocity
        let proposedContentOffsetCenterX = proposedContentOffset.x + (collectionView!.bounds.size.width / 2)
        
        // Get the target rect considering the proposed offset
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height)
        
        // Get layout attributes within the target rect
        guard let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        var closestAttribute: UICollectionViewLayoutAttributes?
        for layoutAttributes in layoutAttributesArray {
            // Find the attribute closest to the center
            if closestAttribute == nil || abs(layoutAttributes.center.x - proposedContentOffsetCenterX) < abs(closestAttribute!.center.x - proposedContentOffsetCenterX) {
                closestAttribute = layoutAttributes
            }
        }
        
        guard let closest = closestAttribute else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        // Adjust the proposed content offset to center the closest cell
        let newOffsetX = closest.center.x - (collectionView!.bounds.size.width / 2)
        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
    }
}

extension UIColor
{
    convenience init?(_ hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return nil
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue  = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(1.0))
    }
}

extension SheetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISheetPresentationControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let colorModel = colors[indexPath.row]
        cell.configure(with: colorModel)
        
        // Add double-tap gesture
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        cell.addGestureRecognizer(doubleTapGesture)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let colorModel = colors[indexPath.row]
        selectedColor = colorModel
        
        for cell in collectionView.visibleCells {
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.layer.borderWidth = 0
            }
        
        if let previousIndexPath = selectedIndexPath, previousIndexPath != indexPath {
            if let previousCell = collectionView.cellForItem(at: previousIndexPath) {
                previousCell.layer.borderColor = UIColor.clear.cgColor
                previousCell.layer.borderWidth = 0
            }
        }
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) {
            if detentState != 0{
                selectedIndexPath = indexPath
                selectedCell.layer.borderColor = UIColor.lightGray.cgColor
                selectedCell.layer.borderWidth = 3.0
            }
        }
        selectedIndexPath = indexPath
    }
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        guard let selectedDetentIdentifier = sheetPresentationController.selectedDetentIdentifier else { return }
        
        if let layout = collectionView.collectionViewLayout as? MyCollectionViewFlowLayout {
            layout.invalidateLayout()
            
            switch selectedDetentIdentifier {
            case .large:
                for cell in collectionView.visibleCells {
                    if let customCell = cell as? MyCollectionViewCell {
                        customCell.transformToDefault()
                    }
                }
                layout.updateLayoutForLargeDetent()
                collectionView.contentInset = .zero // Reset content inset for full-screen
            default:
                layout.updateLayoutForOtherDetents()
                let sideInset = (self.view.frame.width / 2) - (layout.itemSize.width / 2)
                collectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
            }
            
            DispatchQueue.main.async {
                layout.invalidateLayout()
                self.updateCollectionViewConstraints(for: selectedDetentIdentifier)
            }
        }
        
        updateCollectionViewConstraints(for: selectedDetentIdentifier)
        detentState = selectedDetentIdentifier == .large ? 1 : 0
        titleLabel.text = "Personal Colors"
    }
    
    
    
    private func updateCollectionViewConstraints(for detentIdentifier: UISheetPresentationController.Detent.Identifier) {
        var bottomConstant: CGFloat = 50
        var topConstant: CGFloat = 15
        colorDescriptionView.isHidden = true
        descriptionTitleLabel.isHidden = true
        nameLabel.isHidden = true
        hexLabel.isHidden = true
        colorDescriptionLabel.isHidden = true
        dividerBottom.isHidden = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstant),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.heightAnchor.constraint(equalToConstant: 35),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: xButton.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomConstant),
        ])
        
        if detentIdentifier == .large {
            bottomConstant = 329
            topConstant = 30
            colorDescriptionView.isHidden = false
            descriptionTitleLabel.isHidden = false
            nameLabel.isHidden = false
            hexLabel.isHidden = false
            rgbLabel.isHidden = false
            colorDescriptionLabel.isHidden = false
            dividerBottom.isHidden = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstant),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                titleLabel.heightAnchor.constraint(equalToConstant: 35),
                titleLabel.widthAnchor.constraint(equalToConstant: 200),
                
                collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
                collectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: xButton.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomConstant),
                
                dividerBottom.heightAnchor.constraint(equalToConstant: 1),
                dividerBottom.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
                dividerBottom.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
                dividerBottom.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15),
                
                colorDescriptionView.leadingAnchor.constraint(equalTo: dividerBottom.leadingAnchor),
                colorDescriptionView.trailingAnchor.constraint(equalTo: dividerBottom.trailingAnchor),
                colorDescriptionView.topAnchor.constraint(equalTo: dividerBottom.bottomAnchor, constant: 15),
                colorDescriptionView.heightAnchor.constraint(equalToConstant: 200),
                
                descriptionTitleLabel.topAnchor.constraint(equalTo: colorDescriptionView.topAnchor, constant: 15),
                descriptionTitleLabel.leadingAnchor.constraint(equalTo: colorDescriptionView.leadingAnchor),
                descriptionTitleLabel.trailingAnchor.constraint(equalTo: colorDescriptionView.trailingAnchor),
                descriptionTitleLabel.heightAnchor.constraint(equalToConstant: 30),
                
                nameLabel.leadingAnchor.constraint(equalTo: descriptionTitleLabel.leadingAnchor),
                nameLabel.widthAnchor.constraint(equalToConstant: 300),
                nameLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
                nameLabel.heightAnchor.constraint(equalToConstant: 30),
                
                hexLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
                hexLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                hexLabel.widthAnchor.constraint(equalToConstant: 400),
                hexLabel.heightAnchor.constraint(equalToConstant: 20),
                
                rgbLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
                rgbLabel.leadingAnchor.constraint(equalTo: hexLabel.leadingAnchor, constant: 0),
                rgbLabel.trailingAnchor.constraint(equalTo: colorDescriptionView.trailingAnchor),
                hexLabel.heightAnchor.constraint(equalTo: hexLabel.heightAnchor),
                
                colorDescriptionLabel.topAnchor.constraint(equalTo: hexLabel.bottomAnchor, constant: 10),
                colorDescriptionLabel.leadingAnchor.constraint(equalTo: hexLabel.leadingAnchor),
                colorDescriptionLabel.trailingAnchor.constraint(equalTo: rgbLabel.trailingAnchor),
                hexLabel.heightAnchor.constraint(equalToConstant: 200),
            ])
        }
        
        view.layoutIfNeeded()
    }
    
    
}

class MyCollectionViewCell: UICollectionViewCell {
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true // Start hidden
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(starImageView)
        
        NSLayoutConstraint.activate([
            starImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            starImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 50),
            starImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ColorModel) {
        backgroundColor = UIColor(model.color)
        layer.cornerRadius = frame.height / 2
        starImageView.isHidden = !model.isFavorite
    }
    
    func toggleFavorite() {
        starImageView.isHidden.toggle()
    }
    
    func transformToLarge() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }
    }
    
    func transformToDefault() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
        }
    }
}
