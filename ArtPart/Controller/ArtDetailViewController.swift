//
//  ArtDetailViewController.swift
//  ArtPart
//
//  Created by Mihir Thanekar on 8/17/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import PassKit

class ArtDetailViewController: UIViewController {
    @IBOutlet weak var artImage: UIImageView!
    var image: UIImage?
    
    @IBOutlet weak var artDescription: UITextView!
    var desc: String?
    
    
    @IBOutlet weak var payView: UIView!
    
    static let supportedNetworks = [
        PKPaymentNetwork.amex,
        PKPaymentNetwork.discover,
        PKPaymentNetwork.masterCard,
        PKPaymentNetwork.visa
    ]
    
    var paymentToken: PKPaymentToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image {
            artImage.image = image
        }
        if let desc = desc {
            artDescription.text = desc
        }
        
        
        if #available(iOS 10.2, *) {
            let paymentButton = PKPaymentButton(paymentButtonType: .donate, paymentButtonStyle: .black)
            paymentButton.addTarget(self, action: #selector(applePayTriggered), for: .touchUpInside)
            paymentButton.frame.size = payView.frame.size
            payView.addSubview(paymentButton)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func applePayTriggered() {
        let fare = PKPaymentSummaryItem(label: "Minimum Fare", amount: NSDecimalNumber(string: "9.99"), type: .final)
        let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "1.00"), type: .final)
        let total = PKPaymentSummaryItem(label: "Emporium", amount: NSDecimalNumber(string: "10.99"), type: .pending)
        
        let paymentSummaryItems = [fare, tax, total]
        
        let paymentRequest = PKPaymentRequest()
        
        paymentRequest.merchantIdentifier = "merchant.me.mihirthanekar.ArtPart"
        
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.supportedNetworks = ArtDetailViewController.supportedNetworks
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.requiredShippingAddressFields = .all
        //paymentRequest.paymentSummaryItems = makeSummaryItems(requiresInternationalSurcharge: false)
        
        guard let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) else {
            print("INVALID")
            return
        }
        vc.delegate = self
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
}


extension ArtDetailViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        DispatchQueue.main.async {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        paymentToken = payment.token
        
        completion(.success)
    }
    
}
