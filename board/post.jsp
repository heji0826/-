<%@ include file="../includes/header.jsp" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    int postId = Integer.parseInt(request.getParameter("id"));
    String boardType = request.getParameter("boardType");

    if (boardType == null) {
        boardType = "user";  // 기본값을 "user"로 설정
    }

    String query = "";
    if ("admin".equals(boardType)) {
        query = "SELECT ap.post_id, ap.title, ap.created_at, u.nickname, ap.content, ap.attachment_path " + 
                "FROM admin_posts ap " +
                "JOIN users u ON ap.user_id = u.user_id " + 
                "WHERE ap.post_id = ?";
    } else {
        query = "SELECT up.post_id, up.title, up.created_at, u.nickname, up.content, up.attachment_path " + 
                "FROM user_posts up " + 
                "JOIN users u ON up.user_id = u.user_id " + 
                "WHERE up.post_id = ?";
    }

    PreparedStatement stmt = conn.prepareStatement(query);
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
                String attachmentPath = rs.getString("attachment_path");
                if (attachmentPath != null && !attachmentPath.isEmpty()) { 
                %>
                    <p>첨부파일: 
                        <a href="<%= request.getContextPath() %>/board/download.jsp?file=<%= attachmentPath %>">
                            <%= attachmentPath %>
                        </a>
                    </p>
                <% } %>
            <% } %>
            <hr>
            <h3>댓글</h3>
            <form action="../actions/add_comment_action.jsp" method="post">
                <input type="hidden" name="post_id" value="<%= postId %>">
                <input type="hidden" name="board_type" value="<%= boardType %>">
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
                    String commentTable = boardType.equals("admin") ? "admin_comments" : "user_comments";
                    
                    PreparedStatement commentStmt = conn.prepareStatement("SELECT c.comment_id, c.content, c.created_at, u.nickname " + 
                                                                          "FROM " + commentTable + " c " + 
                                                                          "JOIN users u ON c.user_id = u.user_id " +
                                                                          "WHERE c.post_id = ?");
                    commentStmt.setInt(1, postId);
                    ResultSet commentRs = commentStmt.executeQuery();
                    while (commentRs.next()) {
                %>
                <tr>
                    <td><%= commentRs.getString("nickname") %></td>
                    <td><%= commentRs.getString("content") %></td>
                    <td><%= commentRs.getTimestamp("created_at") %></td>
                    <% 
                        if ("admin".equals(session.getAttribute("role")) || 
                            (session.getAttribute("username") != null && session.getAttribute("username").equals(commentRs.getString("nickname")))) { 
                    %>
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
