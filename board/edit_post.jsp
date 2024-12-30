<%@ include file="../includes/header.jsp" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Statement stmt = null;
    ResultSet rs = null;

    int postId = Integer.parseInt(request.getParameter("id"));
    String boardType = request.getParameter("boardType");

    String query = "";
    if ("admin".equals(boardType)) {
        query = "SELECT * FROM admin_posts WHERE post_id = " + postId;
    } else {
        query = "SELECT * FROM user_posts WHERE post_id = " + postId;
    }

    stmt = conn.createStatement();
    rs = stmt.executeQuery(query);
    if (!rs.next()) {
        response.sendRedirect("/web/board/error.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>게시글 수정</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="layout">
    <div class="main-content">
        <div class="container">
            <h1>게시글 수정</h1>
            <form action="../actions/edit_post_action.jsp" method="post" enctype="multipart/form-data">
                <input type="hidden" name="boardType" value="<%= request.getParameter("boardType") %>"> 
                <input type="hidden" id="postId" name="postId" value="<%= postId %>">

                <label for="title">제목:</label>
                <input type="text" id="title" name="title" value="<%= rs.getString("title") %>" required><br>
                
                <label for="content">내용:</label>
                <textarea id="content" name="content" required><%= rs.getString("content") %></textarea><br>
                
                <label for="attachment">첨부파일:</label>
                <input type="file" id="attachment" name="attachment"><br>
                
                <button type="submit" class="button">수정</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
<%
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
%>
