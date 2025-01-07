<%@ include file="../includes/header.jsp" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String boardType = request.getParameter("boardType");
    if (boardType == null || boardType.isEmpty()) {
        boardType = "user"; // 기본 게시판 타입 설정
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>게시글 작성</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="layout">
    <div class="main-content">
        <div class="container">
            <h1>게시글 작성</h1>
            <form action="../actions/write_post_action.jsp" method="post" enctype="multipart/form-data">
                <input type="hidden" name="boardType" value="<%= boardType %>">
                <input type="hidden" name="csrfToken" value="<%= csrfToken %>">

                <label for="title">제목:</label>
                <input type="text" id="title" name="title" required><br>
                
                <label for="content">내용:</label>
                <textarea id="content" name="content" required></textarea><br>
                
                <label for="attachment">첨부파일:</label>
                <input type="file" id="attachment" name="attachment"><br>
                
                <button type="submit" class="button">작성</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>