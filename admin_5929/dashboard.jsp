<%@ include file="../includes/header.jsp" %>
<%@ include file="./admin_check.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>관리자 페이지</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="admin-container">
        <div class="sidebar">
            <h2>관리 메뉴</h2>
            <ul>
                <li><a href="/web/admin_5929/post_notice.jsp">공지사항 작성</a></li>
		        <li><a href="/web/admin_5929/posts_dashboard.jsp">게시판 관리</a></li>
                <li><a href="/web/admin_5929/userlists_dashboard.jsp">회원 관리</a></li>
            </ul>
        </div>
</body>
</html>
