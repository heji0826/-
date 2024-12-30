<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="./dashboard.jsp" %> 
<!DOCTYPE html>
<html>
<head>
    <title>게시판 관리</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="admin-container">
        <div class="content">
            <h2>게시판 관리</h2>
            <form method="get" action="posts_dashboard.jsp">
	    <select id="boardType" name="boardType" required>
                    <option value="user">일반 회원 게시판</option>
                    <option value="admin">관리자 게시판</option>
                </select>
                <button type="submit">조회</button>
            </form>
            <div class="container">
                <table border="1" id="adminPostsTable">
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>내용</th>
                            <th>첨부 파일 경로</th>
                            <th>작성일</th>
                            <th>수정일</th>
                            <th>액션</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        String boardType = request.getParameter("boardType");
                        if (conn != null && boardType != null) {
                            String query = "";
                            if ("admin".equals(boardType)) {
                                query = "SELECT * FROM admin_posts";
                            } else if ("user".equals(boardType)) {
                                query = "SELECT * FROM user_posts";
                            }
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(query);
                            while (rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("post_id") %></td>
                            <td><a href="web/board/post.jsp?postId=<%= rs.getInt("post_id") %>&boardType=<%= boardType %>"><%= rs.getString("title") %></a></td>
                            <td><%= rs.getString("content") %></td>
                            <td><%= rs.getString("attachment_path") %></td>
                            <td><%= rs.getTimestamp("created_at") %></td>
                            <td><%= rs.getTimestamp("updated_at") %></td>
                            <td>
                                <a href="../actions/edit_post_action.jsp?postId=<%= rs.getInt("post_id") %>&boardType=<%= boardType %>">수정</a>
                                <a href="../actions/delete_post_action.jsp?postId=<%= rs.getInt("post_id") %>&boardType=<%= boardType %>">삭제</a>
                            </td>
                        </tr>
                        <%
                            }
                            rs.close();
                            stmt.close();
                        } else {
                        %>
                        <tr>
                            <td colspan="7">데이터를 불러올 수 없습니다.</td>
                        </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
