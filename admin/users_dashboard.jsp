<%@ include file="../db/db_connection.jsp" %>
<%@ include file="./dashboard.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>회원 게시판 관리</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="admin-container">
    <div class="content">
    <h2>회원 게시판 관리</h2>
    <div class="container">
        <table border="1" id="userPostsTable">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자 ID</th>
                    <th>작성일</th>
                    <th>수정일</th>
                    <th>액션</th>
                </tr>
            </thead>
            <tbody>
                <%
                if (conn != null) {
                    String query = "SELECT up.post_id, up.title, up.user_id, u.username, up.created_at, up.updated_at " +
                                   "FROM user_posts up " +
                                   "JOIN users u ON up.user_id = u.user_id";
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("post_id") %></td>
                    <td><a href="../board/post.jsp?id=<%= rs.getInt("post_id") %>"><%= rs.getString("title") %></a></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                    <td><%= rs.getTimestamp("updated_at") %></td>
                    <td>
                        <a href="edit_post.jsp?id=<%= rs.getInt("post_id") %>&board_type=user">수정</a>
                        <a href="delete_post.jsp?id=<%= rs.getInt("post_id") %>&board_type=user">삭제</a>
                    </td>
                </tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                    }
                %>
            </tbody>
        </table>
    </div>
    </div>
</body>
</html>
