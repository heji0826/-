<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Welcome to 59NET</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container {
            text-align: center;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .container h1 {
            font-size: 2.5em;
            color: #2c3e50;
            margin-bottom: 20px;
            text-transform: uppercase;
            font-weight: bold;
        }
        .container p {
            font-size: 1.2em;
            color: #34495e;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        .main-image {
            width: 60%;
            max-width: 600px;
            margin: 20px auto;
            border-radius: 10px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .main-image:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }
        .btn-link {
            display: inline-block;
            background-color: #3498db;
            color: #fff;
            padding: 10px 20px;
            margin-top: 20px;
            text-decoration: none;
            font-size: 1.2em;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }
        .btn-link:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
<div class="layout">
    <div class="main-content">
        <div class="container">
            <h1>오구넷에 오신 것을 환영합니다!</h1>
            <p>오구넷은 취업 준비에 필요한 다양한 정보를 제공합니다.</p>
            <p>회원들과 함께 취업 정보를 나누고, 코딩 실력을 키울 수 있는 <strong>코딩 테스트 문제 은행</strong>을 확인해 보세요.</p>
            <p>아래 이미지를 클릭하면 문제 은행으로 이동합니다.</p>
            <a href="http://13.125.129.134:3000/" target="_blank">
                <img src="/web/images/main.jpg" alt="코딩 테스트 문제 은행으로 이동" class="main-image">
            </a>
            <p><a href="http://13.125.129.134:3000/" target="_blank" class="btn-link">코딩 테스트 문제 은행 바로가기</a></p>
        </div>        
    </div>
</div>
</body>
</html>
