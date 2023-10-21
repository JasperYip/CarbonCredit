
;; title: carbonCreditRequirements
;; version:
;; summary:
;; description:

;; traits
(define-trait nft-trait
  (
    ;; Last token ID, limited to uint range
    (get-last-token-id () (response uint uint))

    ;; URI for metadata associated with the token
    (get-token-uri (uint) (response (optional (string-ascii 256)) uint))

     ;; Owner of a given token identifier
    (get-owner (uint) (response (optional principal) uint))

    ;; Transfer from the sender to a new principal
    (transfer (uint principal principal) (response bool uint))
  )
)

;; token definitions
(define-non-fungible-token carbonCreditToken uint)
(define-data-var  last-token-id uint u0)

;; constants
(define-constant  contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))



;; data vars
;;

;; data maps
;;

;; public functions
(define-read-only (get-last-token-id) 
    (ok (var-get last-token-id))
)

;; This one is basically just a placeholder right now, 
;; because our smart contract does not have a corresponding web interface. 
;; In a real dapp, this function would be in charge of retrieving the URL 
;; of where are NFT data was hosted.
(define-read-only (get-token-uri (token-id uint)) 
    (ok none)
)

(define-read-only (get-owner (token-id uint)) 
    (ok (nft-get-owner? carbonCreditToken token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal)) 
    (begin 
        (asserts! (is-eq tx-sender sender) err-not-token-owner)
        ;; #[filter(token-id, recipient)] 
        (nft-transfer? carbonCreditToken token-id sender recipient)
    )
)


(define-public (mint (recipient principal))
    (let
        (
            (token-id (+ (var-get last-token-id) u1))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        ;; #[filter(recipient)] 
        (try! (nft-mint? carbonCreditToken token-id recipient))
        (var-set last-token-id token-id)
        (ok token-id)
    )
)

;; read only functions
;;

;; private functions
;;

