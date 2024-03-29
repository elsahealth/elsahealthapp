//
//  PaymentSheetFlowController.swift
//  StripeiOS
//
//  Created by Yuki Tokuhiro on 11/4/20.
//  Copyright © 2020 Stripe, Inc. All rights reserved.
//

import Foundation
import UIKit

typealias PaymentOption = PaymentSheet.PaymentOption

extension PaymentSheet {
    /// Represents the ways a customer can pay in PaymentSheet
    enum PaymentOption: Equatable {
        case applePay
        case saved(paymentMethod: STPPaymentMethod)
        case new(paymentMethodParams: STPPaymentMethodParams, shouldSave: Bool)
    }

    /// A class that presents the individual steps of a payment flow
    @available(iOSApplicationExtension, unavailable)
    @available(macCatalystApplicationExtension, unavailable)
    public class FlowController {
        // MARK: - Public properties
        /// Contains details about a payment method that can be displayed to the customer
        public struct PaymentOptionDisplayData {
            /// An image representing a payment method; e.g. the Apple Pay logo or a VISA logo
            public let image: UIImage
            /// A user facing string representing the payment method; e.g. "Apple Pay" or "····4242" for a card
            public let label: String

            init(paymentOption: PaymentOption) {
                image = paymentOption.makeImage()
                switch paymentOption {
                case .applePay:
                    label = STPLocalizedString("Apple Pay", "Text for Apple Pay payment method")
                case .saved(let paymentMethod):
                    label = paymentMethod.paymentSheetLabel
                case .new(let paymentMethodParams, _):
                    label = paymentMethodParams.paymentSheetLabel
                }
            }
        }

        /// This contains all configurable properties of PaymentSheet
        public let configuration: Configuration

        /// Contains information about the customer's desired payment option.
        /// You can use this to e.g. display the payment option in your UI.
        public var paymentOption: PaymentOptionDisplayData? {
            if let selectedPaymentOption = _paymentOption {
                return PaymentOptionDisplayData(paymentOption: selectedPaymentOption)
            }
            return nil
        }

        // MARK: - Private properties

        private var paymentIntent: STPPaymentIntent
        private let savedPaymentMethods: [STPPaymentMethod]
        private lazy var paymentOptionsViewController: ChoosePaymentOptionViewController = {
            let isApplePayEnabled = StripeAPI.deviceSupportsApplePay() && configuration.applePay != nil
            let vc = ChoosePaymentOptionViewController(paymentIntent: paymentIntent,
                                                     savedPaymentMethods: savedPaymentMethods,
                                                     configuration: configuration,
                                                     isApplePayEnabled: isApplePayEnabled,
                                                     delegate: self)
            if #available(iOS 13.0, *) {
                configuration.style.configure(vc)
            }
            return vc
        }()
        private var presentPaymentOptionsCompletion: (() -> ())? = nil
        /// The desired, valid (ie passed client-side checks) payment option from the underlying payment options VC.
        private var _paymentOption: PaymentOption? {
            if let paymentOption = paymentOptionsViewController.selectedPaymentOption,
               paymentOptionsViewController.error == nil {
                return paymentOption
            }
            return nil
        }

        // MARK: - Initializer (Internal)

        required init(paymentIntent: STPPaymentIntent,
                      savedPaymentMethods: [STPPaymentMethod],
                      configuration: Configuration) {
            STPAnalyticsClient.sharedClient.addClass(toProductUsageIfNecessary: PaymentSheet.FlowController.self)
            STPAnalyticsClient.sharedClient.logPaymentSheetInitialized(isCustom: true, configuration: configuration)
            self.paymentIntent = paymentIntent
            self.savedPaymentMethods = savedPaymentMethods
            self.configuration = configuration
        }

        // MARK: - Public methods

        /// An asynchronous failable initializer for PaymentSheet.FlowController
        /// This asynchronously loads the Customer's payment methods, their default payment method, and the PaymentIntent.
        /// You can use the returned PaymentSheet.FlowController instance to e.g. update your UI with the Customer's default Payment Method
        /// - Parameter paymentIntentClientSecret: The client secret of the Stripe PaymentIntent object
        ///     See https://stripe.com/docs/api/payment_intents/object#payment_intent_object-client_secret
        ///     Note: This can be used to complete a payment - don't log it, store it, or expose it to anyone other than the customer.
        /// - Parameter configuration: Configuration for the PaymentSheet. e.g. your business name, Customer details, etc.
        /// - Parameter completion: This is called with either a valid PaymentSheet.FlowController instance or an error if loading failed.
        public static func create(paymentIntentClientSecret: String,
                                  configuration: PaymentSheet.Configuration,
                                  completion: @escaping (Result<PaymentSheet.FlowController, Error>) -> Void) {
            PaymentSheet.load(apiClient: configuration.apiClient,
                              clientSecret: paymentIntentClientSecret,
                              ephemeralKey: configuration.customer?.ephemeralKeySecret,
                              customerID: configuration.customer?.id) { result in
                switch result {
                case .success((let paymentIntent, let paymentMethods)):
                    let manualFlow = FlowController(paymentIntent: paymentIntent,
                                                savedPaymentMethods: paymentMethods,
                                                configuration: configuration)
                    completion(.success(manualFlow))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        /// Presents a sheet where the customer chooses how to pay, either by selecting an existing payment method or adding a new one
        /// Call this when your "Select a payment method" button is tapped
        public func presentPaymentOptions(from presentingViewController: UIViewController, completion: (() -> ())? = nil) {
            guard presentingViewController.presentedViewController == nil else {
                assertionFailure("presentingViewController is already presenting a view controller")
                completion?()
                return
            }
            if let completion = completion {
                presentPaymentOptionsCompletion = completion
            }
            let bottomSheetVC = BottomSheetViewController(contentViewController: paymentOptionsViewController)
            if #available(iOS 13.0, *) {
                configuration.style.configure(bottomSheetVC)
            }
            presentingViewController.presentPanModal(bottomSheetVC)
        }

        /// Completes the payment.
        /// - Parameter presentingViewController: The view controller used to present any view controllers required e.g. to authenticate the customer
        /// - Parameter completion: Called with the result of the payment after any presented view controllers are dismissed
        public func confirmPayment(from presentingViewController: UIViewController, completion: @escaping (PaymentResult) -> ()) {
            guard let paymentOption = _paymentOption else {
                assertionFailure("`confirmPayment` should only be called when `paymentOption` is not nil")
                let error = PaymentSheetError.unknown(debugDescription: "confirmPayment was called with a nil paymentOption")
                completion(.failed(error: error, paymentIntent: paymentIntent))
                return
            }

            let authenticationContext = AuthenticationContext(presentingViewController: presentingViewController)
            PaymentSheet.confirm(configuration: configuration,
                                 applePayPresenter: presentingViewController,
                                 authenticationContext: authenticationContext,
                                 paymentIntent: paymentIntent,
                                 paymentOption: paymentOption) { [weak self] result in
                guard let self = self else { return }
                // Update our paymentIntent
                switch result {
                case let .canceled(paymentIntent: paymentIntent):
                    self.paymentIntent = paymentIntent ?? self.paymentIntent
                case let .failed(error: _, paymentIntent: paymentIntent):
                    self.paymentIntent = paymentIntent ?? self.paymentIntent
                case let .completed(paymentIntent: paymentIntent):
                    self.paymentIntent = paymentIntent
                }
                completion(result)
            }
        }
    }
}

@available(iOSApplicationExtension, unavailable)
@available(macCatalystApplicationExtension, unavailable)
extension PaymentSheet.FlowController: ChoosePaymentOptionViewControllerDelegate {
    func choosePaymentOptionViewController(_ choosePaymentOptionViewController: ChoosePaymentOptionViewController,
                                           shouldAddPaymentMethod paymentMethodParams: STPPaymentMethodParams,
                                           completion: @escaping ((Result<STPPaymentMethod, Error>) -> Void)) {
        // Create the PM
        configuration.apiClient.createPaymentMethod(with: paymentMethodParams) { [weak self] (paymentMethod, error) in
            guard let self = self, let paymentMethod = paymentMethod else {
                let error = error ?? PaymentSheetError.unknown(debugDescription: "Failed to create a PaymentMethod")
                completion(.failure(error))
                return
            }
            guard let customerConfig = self.configuration.customer else {
                assertionFailure()
                completion(.failure(PaymentSheetError.unknown(debugDescription: "Adding PaymentMethod without a customer")))
                return
            }
            // Attach it to Customer
            self.configuration.apiClient.attachPaymentMethod(paymentMethod.stripeId,
                                                             toCustomer: customerConfig.id,
                                                             using: customerConfig.ephemeralKeySecret) { [weak self] error in
                guard self != nil, error == nil else {
                    let error = error ?? PaymentSheetError.unknown(debugDescription: "Failed to attach PaymentMethod to Customer")
                    completion(.failure(error))
                    return
                }
                // Update the default
                DefaultPaymentMethodStore.saveDefault(paymentMethodID: paymentMethod.stripeId, forCustomer: customerConfig.id)
                completion(.success(paymentMethod))
            }
        }
    }

    func choosePaymentOptionViewControllerShouldClose(_ choosePaymentOptionViewController: ChoosePaymentOptionViewController) {
        choosePaymentOptionViewController.dismiss(animated: true) {
            self.presentPaymentOptionsCompletion?()
        }
    }
}

@available(iOSApplicationExtension, unavailable)
@available(macCatalystApplicationExtension, unavailable)
extension PaymentSheet.FlowController: STPAnalyticsProtocol {
    static let stp_analyticsIdentifier: String = "PaymentSheet.FlowController"
}

/// A simple STPAuthenticationContext that wraps a UIViewController
class AuthenticationContext: NSObject, STPAuthenticationContext {
    let presentingViewController: UIViewController

    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        super.init()
    }
    func authenticationPresentingViewController() -> UIViewController {
        return presentingViewController
    }
}
