<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="layout">
    <div class="main-content">
        <div class="container">
            <h1>비밀번호 찾기</h1>
            <form action="/web/actions/forgot_password_action.jsp" method="post">
                <label for="username">아이디:</label>
                <input type="text" id="username" name="username" required><br>

                <label for="security_question">질문:</label>
                <select id="security_question" name="security_question" required>
                    <option value="treasure">내가 아끼는 보물 1호는?</option>
                    <option value="birthplace">내가 태어난 곳은?</option>
                </select><br>

                <label for="security_answer">답변:</label>
                <input type="text" id="security_answer" name="security_answer" required><br>

                <button type="submit" class="button">비밀번호 찾기</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
