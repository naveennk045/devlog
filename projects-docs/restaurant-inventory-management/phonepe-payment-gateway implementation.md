


















`/home/roverz_nk/devhub/official/restaurent-kiosk-backend/.venv/bin/python /home/roverz_nk/devhub/official/restaurent-kiosk-backend/sandbox/payment/main.py` 
`🧾 JSON Payload: {"merchantId": "HIMALAYANSAVOURUAT", "transactionId": "TXN_TEST_0003", "merchantOrderId": "ORDER_TEST_004", "amount": 1000, "storeId": "teststore1", "expiresIn": 1800, "gstBreakup": {}, "invoiceDetails": {}}`
`🔐 Base64 Encoded Payload: eyJtZXJjaGFudElkIjogIkhJTUFMQVlBTlNBVk9VUlVBVCIsICJ0cmFuc2FjdGlvbklkIjogIlRYTl9URVNUXzAwMDMiLCAibWVyY2hhbnRPcmRlcklkIjogIk9SREVSX1RFU1RfMDA0IiwgImFtb3VudCI6IDEwMDAsICJzdG9yZUlkIjogInRlc3RzdG9yZTEiLCAiZXhwaXJlc0luIjogMTgwMCwgImdzdEJyZWFrdXAiOiB7fSwgImludm9pY2VEZXRhaWxzIjoge319`
`🔑 String to Hash: eyJtZXJjaGFudElkIjogIkhJTUFMQVlBTlNBVk9VUlVBVCIsICJ0cmFuc2FjdGlvbklkIjogIlRYTl9URVNUXzAwMDMiLCAibWVyY2hhbnRPcmRlcklkIjogIk9SREVSX1RFU1RfMDA0IiwgImFtb3VudCI6IDEwMDAsICJzdG9yZUlkIjogInRlc3RzdG9yZTEiLCAiZXhwaXJlc0luIjogMTgwMCwgImdzdEJyZWFrdXAiOiB7fSwgImludm9pY2VEZXRhaWxzIjoge319/v3/qr/initf80d3f34-b2f2-4bf0-8d98-15dc2d58271d`
`✅ X-VERIFY Header: 15bed967ed784926c8e98d15dfd5df56a5feefc88f06d97fd76524fa293a5d89###1`

`🚀 Sending request to: https://mercury-uat.phonepe.com/enterprise-sandbox/v3/qr/init`

`🔍 PhonePe Response:`
`{"success":false,"code":"UNAUTHORIZED","message":"UNAUTHORIZED, errorId = 4b18688d-1105-441b-98cb-64e954fc9f63","data":null}`



`https://mercury-uat.phonepe.com/enterprise-sandbox/v3/transaction/HIMALAYANSAVOURUAT/TXN_TEST_0003/status`
`📡 Requesting Transaction Status:`
`https://mercury-uat.phonepe.com/enterprise-sandbox/v3/transaction/HIMALAYANSAVOURUAT/TXN_TEST_0003/status`

`🔍 Response Details:`
`Status Code: 401`
`Response Body: {"success":false,"code":"UNAUTHORIZED","message":"UNAUTHORIZED, errorId = ac8249ea-1f5f-4ddb-b083-e06f03c9040a","data":null}`

`Process finished with exit code 0`
