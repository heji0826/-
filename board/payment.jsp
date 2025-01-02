<%@ include file="../includes/header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제 시스템</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            width: 50%;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }
        .form-group button {
            padding: 10px 20px;
            background-color: #28a745;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .form-group button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <div class="layout">
        <div class="main-content">
            <div class="container">
                <br><br><br>
                <h2>Subscribe to Our Premium Service</h2>
                <p>프리미엄 기능을 이용하시려면, 아래에 결제 정보를 입력하여 구독해주세요.</p>
                <form action="../actions/payment_action.jsp" method="post">
                    <div class="form-group">
                        <label for="name">Name on Card:</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="cardNumber">Card Number:</label>
                        <input type="text" id="cardNumber" name="cardNumber" required>
                    </div>
                    <div class="form-group">
                        <label for="expiryDate">Expiry Date (MM/YY):</label>
                        <input type="text" id="expiryDate" name="expiryDate" required>
                    </div>
                    <div class="form-group">
                        <label for="cvv">CVV:</label>
                        <input type="text" id="cvv" name="cvv" required>
                    </div>
                    <div class="form-group">
                        <button type="submit">구독하기</button>
                    </div>
                </form>
            </div>
        </div>
</div>
</body>
</html>