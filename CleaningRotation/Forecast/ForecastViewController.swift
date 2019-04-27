//
//  ForecastViewController.swift
//  CleaningRotation
//
//  Created by Harry Nelken on 4/27/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

final class ForecastViewController: UIViewController, ForecastViewModelDelegate {

    // MARK: - Outlets

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var forecastLabel: UILabel!

    @IBOutlet weak var notCleaningDayLabel: UILabel!
    @IBOutlet weak var cleaningDayLabel: UILabel!

    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet var separators: [UIView]!

    // MARK: - Nib

    private let nibIdentifier = "ForecastViewController"

    // MARK: - Init

    let viewModel: ForecastViewModel

    init(viewModel: ForecastViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibIdentifier, bundle: Bundle(for: ForecastViewController.self))
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        self.viewModel = ForecastViewModel()
        super.init(nibName: nibIdentifier, bundle: Bundle(for: ForecastViewController.self))
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateForecast()
    }

    // MARK: - ForecastViewModelDelegate

    func updateUIForCleaningDay() {

        updateCommonUI()
    }

    func updateUIForNonCleaningDay() {
        updateCommonUI()
    }

    private func updateCommonUI() {
        detailLabel.text = viewModel.detailText
        cleaningDayLabel.isHidden = !viewModel.isCleaningDay
        notCleaningDayLabel.isHidden = viewModel.isCleaningDay

        forecastLabel.text = viewModel.forecastText
        weekdayLabel.text = viewModel.weekdayText
        dateLabel.text = viewModel.calendarDateText

        separators.forEach { $0.backgroundColor = viewModel.separatorColor }
    }
}

