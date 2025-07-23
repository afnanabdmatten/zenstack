;; ------------------------------------------------------------
;; Contract: ZenStack
;; Description: Minimal Transaction Recording & STX Deposit/Withdraw
;; Language: Clarity for Stacks Blockchain
;; License: MIT
;; ------------------------------------------------------------

;; ---------- Constants ----------
(define-constant ERR-INVALID-AMOUNT u400)
(define-constant ERR-UNAUTHORIZED u401)
(define-constant ERR-NOT-FOUND u404)
(define-constant ERR-INSUFFICIENT-BALANCE u402)

;; ---------- State ----------
(define-data-var next-id uint u1)

(define-map transactions
  uint
  {
    amount: uint,
    sender: principal,
    block-height: uint
  }
)

;; ---------- Process Local Transaction (no STX movement) ----------
(define-public (process-transaction (amount uint))
  (begin
    (asserts! (> amount u0) (err ERR-INVALID-AMOUNT))
    (let (
      (id (var-get next-id))
      (now stacks-block-height)
      (sender tx-sender)
    )
      (map-set transactions id {
        amount: amount,
        sender: sender,
        block-height: now
      })
      (var-set next-id (+ id u1))
      (ok {
        transaction-id: id,
        amount: amount,
        sender: sender,
        block-height: now
      })
    )
  )
)

;; ---------- Deposit STX ----------
(define-public (deposit-stx (amount uint))
  (begin
    (asserts! (> amount u0) (err ERR-INVALID-AMOUNT))
    (let (
      (id (var-get next-id))
      (now stacks-block-height)
      (sender tx-sender)
    )
      (try! (stx-transfer? amount sender (as-contract tx-sender)))
      (map-set transactions id {
        amount: amount,
        sender: sender,
        block-height: now
      })
      (var-set next-id (+ id u1))
      (ok {
        deposit-id: id,
        amount: amount,
        depositor: sender,
        block-height: now
      })
    )
  )
)

;; ---------- Withdraw STX ----------
(define-public (withdraw-stx (amount uint))
  (begin
    (asserts! (> amount u0) (err ERR-INVALID-AMOUNT))
    (let (
      (contract-balance (stx-get-balance (as-contract tx-sender)))
    )
      (asserts! (<= amount contract-balance) (err ERR-INSUFFICIENT-BALANCE))
      (let (
        (id (var-get next-id))
        (now stacks-block-height)
        (sender tx-sender)
      )
        (try! (stx-transfer? amount (as-contract tx-sender) sender))
        (map-set transactions id {
          amount: amount,
          sender: sender,
          block-height: now
        })
        (var-set next-id (+ id u1))
        (ok {
          withdrawal-id: id,
          amount: amount,
          recipient: sender,
          block-height: now
        })
      )
    )
  )
)

;; ---------- Read-Only Functions ----------

(define-read-only (get-transaction (id uint))
  (map-get? transactions id)
)

(define-read-only (get-next-id)
  (var-get next-id)
)

(define-read-only (get-contract-balance)
  (stx-get-balance (as-contract tx-sender))
)