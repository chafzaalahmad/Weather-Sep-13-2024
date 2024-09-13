//
//  WetherViewController.swift
//  Weather
//
//  Created by Afzaal Ahmad on 09/10/24.
//

import Foundation
import UIKit
import Combine

final class WeatherViewController: UIViewController {
    
    //MARK: UI views
    lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = viewModel.weatherImageAccessibilityLabel
        return imageView
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 48)
        return label
    }()
    
    lazy var temperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        
        stackView.addArrangedSubview(weatherImageView)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherImageView.widthAnchor.constraint(equalToConstant: 80),
            weatherImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        return stackView
    }()
    
    lazy var weatherCitiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    lazy var weatherFullDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.isAccessibilityElement = true
        activityIndicatorView.accessibilityLabel = viewModel.loadingDataActivityAccessibilityLabel
        return activityIndicatorView
    }()
    
    lazy var notifyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    lazy var citiInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 30
        
        stackView.addArrangedSubview(weatherCitiLabel)
        stackView.addArrangedSubview(weatherFullDayLabel)
        stackView.addArrangedSubview(weatherDescriptionLabel)
        stackView.addArrangedSubview(activityIndicatorView)
        stackView.addArrangedSubview(notifyLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 30
        
        stackView.addArrangedSubview(temperatureStackView)
        stackView.addArrangedSubview(citiInfoStackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    func layoutTrait(traitCollection:UITraitCollection) {
        mainStackView.axis = (traitCollection.horizontalSizeClass == .regular) ? .horizontal : .vertical
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: (traitCollection.horizontalSizeClass == .regular) ? 120 : 48)
    }
    
    //MARK: private properties
    
    private let viewModel: WeatherViewModel
    private var bindingCancellable: AnyCancellable?
    
    // MARK: Life Cycle
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.viewDidLoad()
        
        registerForTraitChanges([UITraitHorizontalSizeClass.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            self.layoutTrait(traitCollection: self.traitCollection)
        })
    }
    
    // MARK: Public Methods
    
    private func setupUI() {
        title = viewModel.screenTitle
        self.view.backgroundColor = .brown
        self.view.addSubview(mainStackView)
        self.view.addSubview(activityIndicatorView)
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
        setUpLabelConstrains()
    }
    
    private func setUpLabelConstrains() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            mainStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    private func bindViewModel() {
        bindingCancellable = viewModel.output.sink { [weak self] viewState in
            self?.render(viewState)
        }
    }
    
    private func render(_ state: WeatherViewState) {
        switch state {
        case .loading(true):
            notifyLabel.text = ""
            temperatureLabel.text = ""
            weatherCitiLabel.text = ""
            weatherFullDayLabel.text = ""
            weatherDescriptionLabel.text = ""
            activityIndicatorView.startAnimating()
            
        case .loading(false):
            activityIndicatorView.stopAnimating()
            
        case let .message(message):
            notifyLabel.text = message
            temperatureLabel.text = ""
            weatherCitiLabel.text = ""
            weatherFullDayLabel.text = ""
            weatherDescriptionLabel.text = ""
            
        case let .weather(content):
            notifyLabel.text = ""
            temperatureLabel.text = content.temperature
            weatherCitiLabel.text = content.weatherCitiName
            weatherFullDayLabel.text = content.fullDayTemperature
            weatherDescriptionLabel.text = content.description
            if let url = content.weatherIconUrl {
                weatherImageView.loadImage(with: url)
            }
        }
    }
}
