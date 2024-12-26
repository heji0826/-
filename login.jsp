<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>로그인</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="layout">
    <div class="main-content">
        <div class="container">
            <h1>로그인</h1>
            <form action="/web/actions/login_action.jsp" method="post">
                <label for="username">아이디:</label>
                <input type="text" id="username" name="username" placeholder="아이디" required>
                
                <label for="password">비밀번호:</label>
                <input type="password" id="password" name="password" placeholder="비밀번호" required>
                
                <button type="submit" class="button">로그인</button>
            </form>
            <a href="/web/forgot_password.jsp" class="link">비밀번호를 잊으셨나요?</a>
        </div>
    </div>
</div>
</body>
</html>
