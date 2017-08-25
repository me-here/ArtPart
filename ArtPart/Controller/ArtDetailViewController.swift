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
    
    override var previewActionItems: [UIPreviewActionItem] {
        let buyAction = UIPreviewAction(title: "Do something.", style: .default, handler: {
            (action, vc) in
            print("Clicked 'Do something.'")
        })
        return [buyAction]
    }
}


extension ArtDetailViewController: PKPaymentAuthorizationViewControllerDelegate {
    @objc func applePayTriggered() {
        let fare = PKPaymentSummaryItem(label: "Minimum Fare", amount: NSDecimalNumber(string: "9.99"), type: .final)
        let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "1.00"), type: .final)
        
        let totalDouble = (fare.amount as Double) + (tax.amount as Double)
        let total = PKPaymentSummaryItem(label: "ArtPart", amount: NSDecimalNumber(string: "\(totalDouble)"), type: .pending)
        
        let paymentSummaryItems = [fare, tax, total]
        
        let paymentRequest = PKPaymentRequest()
        
        paymentRequest.merchantIdentifier = "merchant.me.mihirthanekar.ArtPart"
        
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.supportedNetworks = ArtDetailViewController.supportedNetworks
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.requiredShippingAddressFields = .postalAddress
        //paymentRequest.paymentSummaryItems = makeSummaryItems(requiresInternationalSurcharge: false)
        
        guard let vc = Optional(PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)) else { // PKPaymentAuthorizationController's init can return nil and we don't want the program to crash accidentally
            print("INVALID")
            return
        }
        vc.delegate = self
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        let paymentCompleteVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentGivenViewController")
        DispatchQueue.main.async {
            controller.dismiss(animated: true, completion: nil)
            self.show(paymentCompleteVC!, sender: self)
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        paymentToken = payment.token
        
        completion(.success)
    }
    
}
