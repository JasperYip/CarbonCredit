
;; title: ect
;; version: 1.0.0
;; summary:
;; description: smart contract that posts a ect to the chain for 1 STX

;; traits
;;

;; token definitions
;; 

;; constants
(define-constant CONTRACT_OWNER (as-contract tx-sender))
(define-constant PRICE u1000000)
(define-constant ERR_STX_TRANSFER (err u100))
;;

;; data vars
(define-data-var total-ects uint u0)
;;

;; data maps
(define-map UserPost principal (string-ascii 3))
;;

;; public functions
(define-public (say-ect)
  (begin
    (unwrap! (stx-transfer? PRICE tx-sender CONTRACT_OWNER) ERR_STX_TRANSFER)
    (map-set UserPost tx-sender "ect")
    (var-set total-ects (+ (var-get total-ects) u1))
    (ok "Success")
  )
)
;;

;; read only functions
(define-read-only (get-total-ects)
  (var-get total-ects)
)

(define-read-only (get-ect (user principal))
  (map-get? UserPost user)
)
;;

;; private functions
;;
