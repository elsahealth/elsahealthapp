//
//  CardDetailsEditView.swift
//  StripeiOS
//
//  Created by Yuki Tokuhiro on 11/11/20.
//  Copyright © 2020 Stripe, Inc. All rights reserved.
//

import Foundation
import UIKit

class CardDetailsEditView: UIView, AddPaymentMethodView, CardScanningViewDelegate {
    let paymentMethodType: STPPaymentMethodType = .card
    var shouldSavePaymentMethod: Bool {
        return saveThisCardCheckboxView.isEnabled && saveThisCardCheckboxView.isSelected
    }

    let billingAddressCollection: PaymentSheet.BillingAddressCollectionLevel
    let merchantDisplayName: String

    var paymentMethodParams: STPPaymentMethodParams? {
        return formView.cardParams
    }
    weak var delegate: AddPaymentMethodViewDelegate?
    
    func markFormErrors(for apiError: Error) -> Bool {
        return formView.markFormErrors(for: apiError)
    }

    lazy var formView: STPCardFormView = {
        let formView = STPCardFormView(billingAddressCollection: billingAddressCollection)
        formView.delegate = self
        return formView
    }()

    lazy var saveThisCardCheckboxView: CheckboxButton = {
        let saveThisCardCheckbox = CheckboxButton()
        saveThisCardCheckbox.label.text = STPLocalizedString("Save this card for future \(merchantDisplayName) payments", "The label of a switch indicating whether to save the user's card for future payment")
        saveThisCardCheckbox.addTarget(self, action: #selector(didSelectSaveThisCard), for: .touchUpInside)
        saveThisCardCheckbox.isSelected = true
        saveThisCardCheckbox.accessibilityLabel = STPLocalizedString("Save this card for future \(merchantDisplayName) payments", "The label of a switch indicating whether to save the user's card for future payment")
        return saveThisCardCheckbox
    }()

    // Card scanning
    @available(iOS 13, *)
    func cardScanningView(_ cardScanningView: CardScanningView, didFinishWith cardParams: STPPaymentMethodCardParams?) {
        if let button = self.lastScanButton {
          button.isUserInteractionEnabled = true
        }
        UIView.animate(withDuration: PaymentSheetUI.defaultAnimationDuration) {
          self.cardScanningView?.isHidden = true
          self.cardScanningView?.alpha = 0
          if let button = self.lastScanButton {
            button.alpha = 1
          }
        }

        if let params = cardParams {
          self.formView.cardParams = STPPaymentMethodParams.init(card: params, billingDetails: nil, metadata: nil)
          let _ = self.formView.nextFirstResponderField()?.becomeFirstResponder()
        }
      }

    @available(iOS 13, *)
    lazy var cardScanningView : CardScanningView? = {
      if !STPCardScanner.cardScanningAvailable() {
        return nil // Don't initialize the scanner
      }
      let scanningView = CardScanningView()
      scanningView.alpha = 0
      scanningView.isHidden = true
      return scanningView
    }()

  weak var lastScanButton: UIButton?
  @objc func scanButtonTapped(_ button: UIButton) {
      if #available(iOS 13.0, *) {
        lastScanButton = button
        if let cardScanningView = cardScanningView {
          button.isUserInteractionEnabled = false
          UIView.animate(withDuration: PaymentSheetUI.defaultAnimationDuration) {
            button.alpha = 0
            cardScanningView.isHidden = false
            cardScanningView.alpha = 1
          }
          self.endEditing(true)
          cardScanningView.start()
        }
      }
    }
  
    init(canSaveCard: Bool, billingAddressCollection: PaymentSheet.BillingAddressCollectionLevel, merchantDisplayName: String, delegate: AddPaymentMethodViewDelegate) {
        self.delegate = delegate
        self.billingAddressCollection = billingAddressCollection
        self.merchantDisplayName = merchantDisplayName
        super.init(frame: .zero)

        var cardScanningPlaceholderView = UIView()
        // Card scanning button
        if #available(iOS 13.0, *) {
          if let cardScanningView = self.cardScanningView {
            cardScanningView.delegate = self
            cardScanningPlaceholderView = cardScanningView
          }
        }
        cardScanningPlaceholderView.isHidden = true

        // [] Save this card
        saveThisCardCheckboxView.isHidden = !canSaveCard

        let contentView = UIStackView(arrangedSubviews: [formView, cardScanningPlaceholderView, saveThisCardCheckboxView])
        contentView.axis = .vertical
        contentView.alignment = .fill
        contentView.spacing = 4
        contentView.setCustomSpacing(8, after: formView)
        contentView.setCustomSpacing(16, after: cardScanningPlaceholderView)

        [contentView].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            formView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    @objc
    private func didSelectSaveThisCard() {
        saveThisCardCheckboxView.isSelected.toggle()
        delegate?.didUpdate(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    override var isUserInteractionEnabled: Bool {
        didSet {
            formView.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
}
// MARK: - Events
/// :nodoc:
extension CardDetailsEditView: EventHandler {
    func handleEvent(_ event: STPEvent) {
        switch event {
        case .shouldDisableUserInteraction:
            saveThisCardCheckboxView.isUserInteractionEnabled = false
            formView.isUserInteractionEnabled = false
            saveThisCardCheckboxView.isEnabled = false
        case .shouldEnableUserInteraction:
            saveThisCardCheckboxView.isUserInteractionEnabled = true
            formView.isUserInteractionEnabled = true
            saveThisCardCheckboxView.isEnabled = true
        default:
            break
        }
    }
}

/// :nodoc:
extension CardDetailsEditView: STPFormViewDelegate {
    func formView(_ form: STPFormView, didChangeToStateComplete complete: Bool) {
        delegate?.didUpdate(self)
    }
  
    func formViewWillBecomeFirstResponder(_ form: STPFormView) {
      if #available(iOS 13, *) {
        cardScanningView?.stop()
      }
    }
  
    func formView(_ form: STPFormView, didTapAccessoryButton button: UIButton) {
      self.scanButtonTapped(button)
    }
}
