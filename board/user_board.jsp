<%@ include file="../includes/header.jsp" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원 게시판</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="layout">
    <div class="main-content">
        <div class="container">
            <h1>회원 게시판</h1>
            <button class="button" onclick="window.location.href='/web/board/write_post.jsp?boardType=user'">글쓰기</button>
            <br><br>
            <table border="1" class="table">
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>보기</th>
                </tr>
                <%
                    if (conn != null) {
                        Statement stmt = conn.createStatement();
                        String query = "SELECT p.post_id, p.title, u.nickname, p.created_at FROM user_posts p "
                                     + "JOIN users u ON p.user_id = u.user_id";
                        ResultSet rs = stmt.executeQuery(query);
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("post_id") %></td>
                    <td><%= rs.getString("title") %></td>
                    <td><%= rs.getString("nickname") %></td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                    <td><a href="post.jsp?id=<%= rs.getInt("post_id") %>&boardType=user">보기</a></td>
                </tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                    } else {
                %>
                <tr>
                    <td colspan="5">데이터베이스 연결에 실패했습니다.</td>
                </tr>
                <% } %>
            </table>
        </div>
    </div>
</div>
</body>
</html>
