;; tickets-90stx-mint-raffle-N, , where N - raffle number like 1,2,3...

;; Storage
(define-map presale-count principal uint)

;; Constants and Errors
(define-constant mint-price u90000000)
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u401))
(define-constant ERR-NOT-FOUND (err u404))
(define-constant ERR-SALE-NOT-ACTIVE (err u500))
(define-constant ERR-NO-MINTPASS-REMAINING (err u501))
(define-constant ERR-BURN-NOT-ACTIVE (err u502))
(define-constant ERR-FATAL (err u999))

;; Variables
(define-data-var mintpass-sale-active bool false)
(define-data-var sale-active bool false)
(define-data-var burn-active bool false)

;; Get presale balance
(define-read-only (get-presale-balance (account principal))
  (default-to u0
    (map-get? presale-count account)))

;; Check mintpass sales active
(define-read-only (mintpass-enabled)
  (ok (var-get mintpass-sale-active)))

;; Check public sales active
(define-read-only (public-enabled)
  (ok (var-get sale-active)))

;; Check burn active
(define-read-only (burn-enabled)
  (ok (var-get burn-active)))

;; Set mintpass sale flag (only contract owner)
(define-public (flip-mintpass-sale)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER)  ERR-NOT-AUTHORIZED)
    (var-set sale-active false)
    (var-set mintpass-sale-active (not (var-get mintpass-sale-active)))
    (ok (var-get mintpass-sale-active))))

;; Set public sale flag (only contract owner)
(define-public (flip-sale)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set mintpass-sale-active false)
    (var-set sale-active (not (var-get sale-active)))
    (ok (var-get sale-active))))

;; Set burn flag (only contract owner)
(define-public (flip-burn)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set burn-active (not (var-get burn-active)))
    (ok (var-get burn-active))))

;; Claim NFT (1 + 1 jackpot)
(define-public (claim)
  (if (var-get mintpass-sale-active)
    (mintpass-mint tx-sender)
    (public-mint tx-sender)))

;; Claim 3 NFT (3 + 4 jackpot)
(define-public (claim-three)
  (begin
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (contract-call? .jackpot-tickets-90stx-may-22 mint tx-sender))
    (ok true)))

;; Claim 5 NFT (5 + 7 jackpot)
(define-public (claim-five)
  (begin
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (contract-call? .jackpot-tickets-90stx-may-22 mint tx-sender))
    (try! (contract-call? .jackpot-tickets-90stx-may-22 mint tx-sender))
    (ok true)))

;; Claim 10 NFT (10 + 15 jackpot)
(define-public (claim-ten)
  (begin
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (contract-call? .jackpot-tickets-90stx-may-22 mint tx-sender))
    (try! (contract-call? .jackpot-tickets-90stx-may-22 mint tx-sender))
    (try! (contract-call? .jackpot-tickets-90stx-may-22 mint tx-sender))
    (try! (contract-call? .jackpot-tickets-90stx-may-22 mint tx-sender))
    (try! (contract-call? .jackpot-tickets-90stx-may-22 mint tx-sender))
    (ok true)))

;; Claim jackpot ticket (only contract owner)
(define-public (mint-jackpot-ticket (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (try! (contract-call? .jackpot-tickets-90stx-may-22 mint new-owner))
    (ok true)))

;; Check ticket
(define-public (check-ticket (id uint))
  (begin
    (try! (burn-ticket id))
    (ok true)))

;; Check jackpot ticket
(define-public (check-jackpot-ticket (id uint))
  (begin
    (try! (burn-jackpot id))
    (ok true)))

;; Check 5 jackpot ticket
(define-public (check-jackpot-tickets-five (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
    (try! (burn-jackpot id1))
    (try! (burn-jackpot id2))
    (try! (burn-jackpot id3))
    (try! (burn-jackpot id4))
    (try! (burn-jackpot id5))
    (ok true)))

;; Check 10 jackpot ticket
(define-public (check-jackpot-tickets-ten (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint) (id6 uint) (id7 uint) (id8 uint) (id9 uint) (id10 uint))
  (begin
    (try! (burn-jackpot id1))
    (try! (burn-jackpot id2))
    (try! (burn-jackpot id3))
    (try! (burn-jackpot id4))
    (try! (burn-jackpot id5))
    (try! (burn-jackpot id6))
    (try! (burn-jackpot id7))
    (try! (burn-jackpot id8))
    (try! (burn-jackpot id9))
    (try! (burn-jackpot id10))
    (ok true)))    

;; Internal - Mint NFT using Mintpass
(define-private (mintpass-mint (new-owner principal))
  (let ((presale-balance (get-presale-balance new-owner)))
    (asserts! (> presale-balance u0) ERR-NO-MINTPASS-REMAINING)
    (map-set presale-count
              new-owner
              (- presale-balance u1))
  (try! (contract-call? .tickets-90stx-raffle-1 mint new-owner))
  (try! (contract-call? .jackpot-tickets-90stx-may-22 mint new-owner))
  (ok true)))

;; Internal - Mint NFT via public sale
(define-private (public-mint (new-owner principal))
  (begin
    (asserts! (var-get sale-active) ERR-SALE-NOT-ACTIVE)
    (try! (contract-call? .tickets-90stx-raffle-1 mint new-owner))
    (try! (contract-call? .jackpot-tickets-90stx-may-22 mint new-owner))
    (ok true)))

;; Internal - Burn ticket
(define-private (burn-ticket (id uint))
  (let
    ((owner (unwrap! (unwrap! (contract-call? .tickets-90stx-raffle-1 get-owner id) ERR-FATAL) ERR-NOT-FOUND)))
    (asserts! (is-eq owner tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (var-get burn-active) ERR-BURN-NOT-ACTIVE)
    (try! (contract-call? .tickets-90stx-raffle-1 burn id tx-sender))
    (ok true)))

;; Internal - Burn jackpot ticket
(define-private (burn-jackpot (id uint))
  (let
    ((owner (unwrap! (unwrap! (contract-call? .jackpot-tickets-90stx-may-22 get-owner id) ERR-FATAL) ERR-NOT-FOUND)))
    (asserts! (is-eq owner tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (var-get burn-active) ERR-BURN-NOT-ACTIVE)
    (try! (contract-call? .jackpot-tickets-90stx-may-22 burn id tx-sender))
    (ok true)))

;; Register this contract as allowed to mint
(as-contract (contract-call? .tickets-90stx-raffle-1 set-mint-address)) ;; set raffle tickets contract as mint address
(as-contract (contract-call? .jackpot-tickets-90stx-may-22 set-mint-address)) ;; set jackpot tickets contract as mint address

;; Mintpasses
(map-set presale-count 'SPW4Z5DWXR1N6P83ZPGG50MD27DK5P5N85KGMV1E u50)
(map-set presale-count 'SP02A6KK9V9M4ZK6YVNVGJ5T2954JWMF2P7SNKNT u10)
