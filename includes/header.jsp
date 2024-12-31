<%@ page import="javax.servlet.http.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    Boolean isAdmin = (session != null && session.getAttribute("is_admin") != null) 
                      ? (Boolean) session.getAttribute("is_admin") 
                      : false;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MyWebApp</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="header">
    <a href="/web/index.jsp">
        <img src="/web/images/logo.png" alt="Logo" class="logo">
    </a>
    <nav class="menu">
        <a href="/web/board/user_board.jsp">회원 게시판</a>
        <a href="/web/board/admin_board.jsp">취업 정보 게시판</a>
        <% if (isAdmin != null && isAdmin) { %>
            <a href="/web/admin/main_dashboard.jsp">관리자 페이지</a>
        <% } %>
    </nav>
    <div class="user-menu">
        <% if (username == null) { %>
            <a href="/web/login.jsp">로그인</a>
            <a href="/web/signup.jsp">회원가입</a>
        <% } else { %>
            <a href="/web/profile.jsp">내 정보</a>
            <a href="/web/logout.jsp">로그아웃</a>
        <% } %>
    </div> 
</div>
</body>
</html>
