<%@ include file="includes/header.jsp" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기 결과</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .button {
            color: blue;
            text-decoration: none;
        }
        
        .button:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="layout">
    <div class="main-content">
        <div class="container">
            <h1>비밀번호 찾기</h1>
            <%
                String new_password = request.getParameter("new_password");
                new_password = URLDecoder.decode(new_password, "UTF-8");
                if (new_password != null && !new_password.isEmpty()) {
            %>
            <p>임시 비밀번호가 발급되었습니다. 아래 임시 비밀번호를 사용하여 로그인하세요:</p>
            <p><strong style="color: red; font-size: 20px;"><%= new_password %></strong></p>
            <p>로그인 후 반드시 비밀번호를 변경하시기 바랍니다.</p>
            <a href="login.jsp" class="button">로그인 페이지로 이동</a>
            <% } else { %>
            <p>임시 비밀번호 발급에 실패했습니다. 다시 시도해주세요.</p>
            <button onclick="history.back()">돌아가기</button>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>
