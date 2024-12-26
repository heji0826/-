<%@ include file="../includes/header.jsp" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    int postId = Integer.parseInt(request.getParameter("id"));
    String boardType = "user";

    if ("admin".equals(session.getAttribute("role"))) {
        boardType = "admin";
    }

    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM " + boardType + "_posts WHERE post_id = ?");
    stmt.setInt(1, postId);
    ResultSet rs = stmt.executeQuery();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시물 상세보기</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="layout">
    <div class="main-content">
        <div class="container">
            <% if (rs.next()) { %>
                <h1><%= rs.getString("title") %></h1>
                <p>작성자: <%= rs.getString("nickname") %></p>
                <p>작성일: <%= rs.getTimestamp("created_at") %></p>
                <p><%= rs.getString("content") %></p>
                <% 
                if (rs.getString("attachment_path") != null) { 
                %>
                    <p>첨부파일: <a href="../uploads/<%= rs.getString("attachment_path") %>"><%= rs.getString("attachment_path") %></a></p>
                <% } %>
            <% } %>
            <hr>
            <h3>댓글</h3>
            <form action="../actions/add_comment_action.jsp" method="post">
                <input type="hidden" name="post_id" value="<%= postId %>">
                댓글 내용: <textarea name="content" required></textarea><br>
                <button type="submit">댓글 달기</button>
            </form>
            <table border="1">
                <tr>
                    <th>작성자</th>
                    <th>내용</th>
                    <th>작성일</th>
                    <% if ("admin".equals(session.getAttribute("role"))) { %>
                        <th>관리</th>
                    <% } %>
                </tr>
                <%
                    PreparedStatement commentStmt = conn.prepareStatement("SELECT * FROM comments WHERE post_id = ? AND board_type = ?");
                    commentStmt.setInt(1, postId);
                    commentStmt.setString(2, boardType);
                    ResultSet commentRs = commentStmt.executeQuery();

                    while (commentRs.next()) {
                %>
                <tr>
                    <td><%= commentRs.getString("nickname") %></td>
                    <td><%= commentRs.getString("content") %></td>
                    <td><%= commentRs.getTimestamp("created_at") %></td>
                    <% if ("admin".equals(session.getAttribute("role")) || session.getAttribute("username").equals(commentRs.getString("nickname"))) { %>
                        <td>
                            <a href="../actions/delete_comment_action.jsp?id=<%= commentRs.getInt("comment_id") %>">삭제</a>
                        </td>
                    <% } %>
                </tr>
                <%
                    }
                    commentRs.close();
                    commentStmt.close();
                %>
            </table>
        </div>
    </div>
</div>
</body>
</html>