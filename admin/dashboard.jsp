<%@ include file="../includes/header.jsp" %>
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
                <li><a href="/web/admin/post_notice.jsp">공지사항 게시판</a></li>
		<li><a href="/web/admin/posts_dashboard.jsp">채용공고 게시판</a></li>
                <li><a href="/web/admin/users_dashboard.jsp">회원 게시판</a></li>
                <li><a href="/web/admin/userlists_dashboard.jsp">회원 관리</a></li>
            </ul>
        </div>
</body>
</html>
