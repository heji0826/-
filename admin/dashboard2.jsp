<%@ include file="../includes/header.jsp" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>관리자 페이지</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="admin-container">
        <div class="sidebar">
            <h2>관리 메뉴</h2>
            <ul>
                <li><a href="#">채용공고 게시판</a></li>
                <li><a href="#">회원 게시판</a></li>
                <li><a href="#">회원 관리</a></li>
            </ul>
        </div>
        <div class="content">
        <h1>Admin Page</h1>
        
        <!-- Admin Posts 관리 -->
        <h2>Admin Posts</h2>
        <div class="form-container">
            <h3>새 글 작성</h3>
            <form id="adminPostForm">
                <input type="hidden" id="adminPostId" name="post_id">
                <input type="text" id="adminPostTitle" name="title" placeholder="제목" required>
                <textarea id="adminPostContent" name="content" placeholder="내용" required></textarea>
                <input type="text" id="adminPostAttachment" name="attachment_path" placeholder="첨부 파일 경로">
                <button type="submit">저장</button>
            </form>
        </div>
        <table border="1" id="adminPostsTable">
            <thead>
                <tr>
                    <th>ID</th>
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
                if (conn != null) {
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM admin_posts");
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("post_id") %></td>
                    <td><%= rs.getString("title") %></td>
                    <td><%= rs.getString("content") %></td>
                    <td><%= rs.getString("attachment_path") %></td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                    <td><%= rs.getTimestamp("updated_at") %></td>
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
</body>
</html>
