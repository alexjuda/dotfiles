;; Shows ledger sections in aerial.nvim outline as classes.
(section
  headline: (headline
    item: (item) @name
    (#set! "kind" "Class"))) @symbol

;; This could be used for showing individual transactions. I'd have to adjust the aerial filters for this to work.
(transaction
  date: (date)
  txn: (txn)
  narration: (narration) @name
  (#set! "kind" "Variable")) @symbol
