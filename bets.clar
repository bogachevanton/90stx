;; Constats and Errors
(define-constant WALLET 'principal) ;; place wallet principal
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u101))

;; Variables
(define-data-var bet-price-stx uint u0) ;; change price STX (1 STX = 1 000 000 microstacks)
(define-data-var bet-price-ban uint u0) ;; change price BANANA (1 BAN = 1 000 000 microbananas)
(define-data-var last-bet-id-stx uint u0)
(define-data-var last-bet-id-ban uint u0)

;; Functions
;; Make bet in STX (all users)
;; date - att in function (like date (07.04.2022) + time (18:30:05))
;; Use stx-transfer? function
;; Update bet id with + 1 itteration
;; Print date
(define-public (bet-stx (date (string-ascii 40)))
  (begin
    (try! (stx-transfer? (var-get bet-price-stx) tx-sender WALLET))
    (var-set last-bet-id-stx (+ (var-get last-bet-id-stx) u1))
    (print date)
    (ok true)))

;; Make bet in BANANA (all users)
;; date - att in function (like date (07.04.2022) + time (18:30:05))
;; Use contract-call? function for FT token BANANA by Bitcoin Monkeys and transfer funds with att (amount, sender, receive, memo)
;; Update bet id with + 1 itteration
;; Print date
(define-public (bet-banana (date (string-ascii 40)))
  (begin
    (try! (contract-call? .btc-monkeys-bananas transfer (var-get bet-price-ban) tx-sender WALLET (some 0x00)))
    (var-set last-bet-id-ban (+ (var-get last-bet-id-ban) u1))
    (print date)
    (ok true)))

;; Set price in STX (only contract owner)
;; price - att in uSTX
;; Change price in STX
;; Set new price
(define-public (set-price-stx (price uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set bet-price-stx price)
    (ok true)))

;; Set price in BANANA (only contract owner)
;; price - att in uBAN
;; Change price in BAN
;; Set new price
(define-public (set-price-ban (price uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set bet-price-ban price)
    (ok true)))

;; Price in STX
;; Just check price
(define-read-only (get-price-in-stx)
  (ok (var-get bet-price-stx)))

;; Price in BANANA
;; Just check price
(define-read-only (get-price-in-banana)
  (ok (var-get bet-price-ban)))

;; Prize pool in STX
;; Bet ID in STX * price in STX = prize pool
(define-read-only (get-prize-pool-stx)
  (ok (* (var-get last-bet-id-stx) (var-get bet-price-stx))))

;; Prize pool in BANANA
;; Bet ID in BANANA * price in BANANA = prize pool
(define-read-only (get-prize-pool-banana)
  (ok (* (var-get last-bet-id-ban) (var-get bet-price-ban))))