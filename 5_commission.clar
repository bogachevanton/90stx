commission-tickets-90stx-mint-draw-1-stxnft

(define-public (pay (id uint) (price uint))
    (begin
        (try! (stx-transfer? (/ (* price u250) u10000) tx-sender 'principal))
        (try! (stx-transfer? (/ (* price u250) u10000) tx-sender 'principal))
        (ok true)))