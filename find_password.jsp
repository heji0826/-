<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기 결과</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="layout">
    <div class="main-content">
        <div class="container">
            <h1>비밀번호 찾기 결과</h1>
            <%
                String user_name = (String) session.getAttribute("username");
                String pass_word = (String) session.getAttribute("password");

                if (user_name != null && pass_word != null) {
            %>
                    <p>아이디: <%= user_name %></p>
                    <p>비밀번호: <%= pass_word %></p>
                    <a href="login.jsp"><button>로그인</button></a>
            <% 
                } else {
            %>
                    <p>알 수 없는 오류가 발생했습니다. 다시 시도해 주세요.</p>
                    <button onclick="history.back()">돌아가기</button>
            <% 
                }
            %>
        </div>
    </div>
</div>
</body>
</html>