------------------------------------------------------------
-- Do not edit, automatically generated with R package validatedb.
-- validatedb: 0.3.0.9000
-- validate: 1.1.0
-- R version 4.1.2 (2021-11-01)
-- Database: '', Table: 'transactions'
-- Date: 2021-11-29
------------------------------------------------------------

--------------------------------------
--  is_uuid:  
--  validation rule:  length(uid) == length(uuid::UUIDgenerate())

SELECT `uid`, 'is_uuid' AS `rule`, 1 AS `fail`
FROM `transactions`
WHERE (length(`uid`) != length('51429ba8-7eaf-4ff4-857b-898adcbf821f'))
UNION ALL
SELECT `uid`, 'is_uuid' AS `rule`, NULL AS `fail`
FROM `transactions`
WHERE (((length(`uid`) != length('f1efeff3-234a-4181-a8c9-27338e0314b3')) IS NULL))

--------------------------------------

UNION ALL

--------------------------------------
--  type_ok:  
--  validation rule:  transaction_type %in% c("payment", "recovery", "case_adjustment")

SELECT `uid`, 'type_ok' AS `rule`, 1 AS `fail`
FROM `transactions`
WHERE (NOT(`transaction_type` IN ('payment', 'recovery', 'case_adjustment')))
UNION ALL
SELECT `uid`, 'type_ok' AS `rule`, NULL AS `fail`
FROM `transactions`
WHERE (((NOT(`transaction_type` IN ('payment', 'recovery', 'case_adjustment'))) IS NULL))

--------------------------------------

UNION ALL

--------------------------------------
--  amount_gt_zero_if_not_recovery:  
--  validation rule:  transaction_amount > 0

SELECT `uid`, 'amount_gt_zero_if_not_recovery' AS `rule`, 1 AS `fail`
FROM `transactions`
WHERE (`transaction_amount` <= 0.0)
UNION ALL
SELECT `uid`, 'amount_gt_zero_if_not_recovery' AS `rule`, NULL AS `fail`
FROM `transactions`
WHERE (((`transaction_amount` <= 0.0) IS NULL))

--------------------------------------
