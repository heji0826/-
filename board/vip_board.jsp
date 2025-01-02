<%@ include file="../includes/header.jsp" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>자소서 첨삭</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="layout">
    <div class="main-content">
        <div class="container">
            <h1>자소서 첨삭</h1>
            <% 
                boolean is_Vip = (session != null && session.getAttribute("is_vip") != null)
                               ? (Boolean) session.getAttribute("is_vip")
                               : false;
                String targetUrl = is_Vip ? "/web/board/write_post.jsp?boardType=vip" : "/web/board/payment.jsp";
            %>
            <button class="button" onclick="location.href='<%= targetUrl %>';">글쓰기</button>
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
                        if (conn != null) {
                            Statement stmt = conn.createStatement();
                            String query = "SELECT ap.post_id, ap.title, ap.created_at, u.nickname " +
                                           "FROM vip_posts ap " +
                                           "JOIN users u ON ap.user_id = u.user_id ";
            
                            // 검색 필드와 검색어 조건 추가
                            String searchField = request.getParameter("searchField");
                            String search = request.getParameter("search");
                            if (searchField != null && search != null && !search.trim().isEmpty()) {
                                query += "WHERE " + searchField + " LIKE '%" + search + "%' ";
                            }
            
                            // 정렬 조건 추가
                            query += "ORDER BY ap.created_at DESC";
                            ResultSet rs = stmt.executeQuery(query);
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("post_id") %></td>
                        <td><%= rs.getString("title") %></td>
                        <td><%= rs.getString("nickname") %></td>
                        <td><%= rs.getTimestamp("created_at") %></td>
                        <td><a href="post.jsp?id=<%= rs.getInt("post_id") %>&boardType=vip" class="btn-view">보기</a></td>
                    </tr>
                    <%
                            }
                            rs.close();
                            stmt.close();
                        } else {
                    %>
                    <tr>
                        <td colspan="5" class="error-message">데이터베이스 연결에 실패했습니다.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>            
        </div>
    </div>
</div>
</body>
</html>
