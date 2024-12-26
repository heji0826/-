<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>회원가입</title>
    <link rel="stylesheet" href="css/style.css" />
</head>
<body>
<div class="layout">
    <div class="main-content">
        <div class="container">
            <h1>회원가입</h1>
            <form action="actions/signup_action.jsp" method="post" accept-charset="UTF-8">
                <label for="name">이름:</label>
                <input type="text" id="name" name="name" required /><br />

                <label for="username">아이디:</label>
                <input type="text" id="username" name="username" required /><br />

                <label for="password">비밀번호:</label>
                <input type="password" id="password" name="password" required /><br />

                <label for="email">이메일:</label>
                <input type="email" id="email" name="email" required /><br />

                <label for="nickname">닉네임:</label>
                <input type="text" id="nickname" name="nickname" required /><br />

                <label for="phone">휴대폰 번호:</label>
                <input type="text" id="phone" name="phone" required /><br />

                <label for="security_question">비밀번호 질문:</label>
                <select id="security_question" name="security_question" required>
                    <option value="treasure">내가 아끼는 보물 1호는?</option>
                    <option value="birthplace">내가 태어난 곳은?</option>
                </select><br />

                <label for="security_answer">답변:</label>
                <input type="text" id="security_answer" name="security_answer" required /><br />

                <button type="submit" class="button">가입하기</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
