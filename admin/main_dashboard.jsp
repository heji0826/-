<%@ include file="./dashboard.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if (loggedInUserId == null) {
        response.sendRedirect("/web/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>관리자 페이지</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="layout">
        <div class="content">
            <div class="admin-container">
                <h1>관리자 페이지입니다.</h1>
                <img src="/web/images/adminPage.jpg" alt="adminPage Image" class="admin-image">
            </div>        
        </div>
    </div>
</body>
</html>
