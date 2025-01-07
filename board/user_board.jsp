<%@ include file="../includes/header.jsp" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Integer loggedInUserId = (Integer) session.getAttribute("user_id");

    if (loggedInUserId == null) {
        response.sendRedirect("/web/login.jsp");
        return;
    }
%>
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
            <br>
            <form method="get" action="" class="search-container">
                <select name="searchField" class="search-select" required>
                    <option value="title" <%= "title".equals(request.getParameter("searchField")) ? "selected" : "" %>>제목</option>
                    <option value="nickname" <%= "nickname".equals(request.getParameter("searchField")) ? "selected" : "" %>>작성자</option>
                    <option value="content" <%= "content".equals(request.getParameter("searchField")) ? "selected" : "" %>>내용</option>
                </select>
                <input type="text" name="search" class="search-input" placeholder="검색어를 입력하세요" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" required>
                <button type="submit" class="search-button">검색</button>
            </form>
            <br>

            <table class="posts-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>보기</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        try {
                            if (conn != null) {
                                String searchField = request.getParameter("searchField");
                                String search = request.getParameter("search");
                                String query = "SELECT p.post_id, p.title, u.nickname, p.created_at FROM user_posts p " +
                                               "JOIN users u ON p.user_id = u.user_id";
                                if (searchField != null && search != null && !search.trim().isEmpty()) {
                                    query += " WHERE " + searchField + " LIKE ?";
                                }
                                query += " ORDER BY p.created_at DESC";
                                pstmt = conn.prepareStatement(query);
                                if (searchField != null && search != null && !search.trim().isEmpty()) {
                                    pstmt.setString(1, "%" + search + "%");
                                }
                                rs = pstmt.executeQuery();
                                while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("post_id") %></td>
                        <td><%= rs.getString("title") %></td>
                        <td><%= rs.getString("nickname") %></td>
                        <td><%= rs.getTimestamp("created_at") %></td>
                        <td><a href="post.jsp?id=<%= rs.getInt("post_id") %>&boardType=user" class="btn-view">보기</a></td>
                    </tr>
                    <%
                                }
                            } else {
                    %>
                    <tr>
                        <td colspan="5" class="error-message">데이터베이스 연결에 실패했습니다.</td>
                    </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5' class='error-message'>오류: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                        }
                    %>
                </tbody>
            </table>            
        </div>
    </div>
</div>
</body>
</html>