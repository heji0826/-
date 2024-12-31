<%@ include file="../db/db_connection.jsp" %>
<%@ include file="./dashboard.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
int userId = Integer.parseInt(request.getParameter("user_id")); // user_id를 request에서 가져옴
%>
<html>
<head>
    <title>회원 정보 조회</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="content">
        <h1>회원 정보 조회</h1>
        <table border="1" class="table">
            <tr>
                <th>번호</th>
                <th>아이디</th>
                <th>닉네임</th>
                <th>이메일</th>
                <th>가입일</th>
                <th>유형</th>
                <th>회원 삭제</th>
            </tr>
            <%
                if (conn != null) {
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        String query = "SELECT * FROM users WHERE user_id = ?";
                        pstmt = conn.prepareStatement(query);
                        pstmt.setInt(1, userId);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            boolean is_Admin = rs.getBoolean("is_admin");
            %>
            <tr>
                <td><%= rs.getInt("user_id") %></td>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("nickname") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td>
                    <%
                        if (is_Admin) {
                            out.print("관리자");
                        } else {
                            out.print("일반회원");
                        }
                    %>
                </td>
                <td>
                    <%
                        if (!is_Admin) {
                    %>
                    <a href="/web/actions/delete_user_action.jsp?user_id=<%= rs.getInt("user_id") %>" class="button">삭제</a>
                    <%
                        } else {
                    %>
                    삭제 불가
                    <%
                        }
                    %>
                </td>
            </tr>
            <%
                        }
                        rs.close();
                        pstmt.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("데이터베이스 오류: " + e.getMessage());
                    }
                }
            %>
        </table>
    <div>
        <h2>작성글 조회</h2>
        <table border="1" class="table">
            <tr>
                <th>게시글ID</th>
                <th>제목</th>
                <th>작성일</th>
                <th>수정일</th>
                <th>게시판 종류</th>
                <th>액션</th>
            </tr>
            <%
                if (conn != null) {
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        String query = "SELECT post_id, title, created_at, updated_at FROM user_posts WHERE user_id = ?";
                        String boardType = "user";
                        pstmt = conn.prepareStatement(query);
                        pstmt.setInt(1, userId);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("post_id") %></td>
                <td><a href="web/user_board.jsp?id=<%= rs.getInt("post_id") %>"><%= rs.getString("title") %></a></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getTimestamp("updated_at") %></td>
                <td>회원 게시판</td>
                <td>
                    <a href="/web/board/edit_post.jsp?id=<%= rs.getInt("post_id") %>&boardType=user">수정</a>
                    <a href="/web/actions/delete_post_action.jsp?postId=<%= rs.getInt("post_id") %>&board_type=user">삭제</a>
                </td>
            </tr>
            <%
                        }
                        rs.close();
                        pstmt.close();
                        
                        // admin_posts에서 게시물 가져오기
                        String adminPostsQuery = "SELECT post_id, title, created_at, updated_at FROM admin_posts WHERE user_id = ?";
                        pstmt = conn.prepareStatement(adminPostsQuery);
                        pstmt.setInt(1, userId);
                        rs = pstmt.executeQuery();
    
                        while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("post_id") %></td>
                                <td><a href="web/admin_board.jsp?id=<%= rs.getInt("post_id") %>"><%= rs.getString("title") %></a></td>
                                <td><%= rs.getTimestamp("created_at") %></td>
                                <td><%= rs.getTimestamp("updated_at") %></td>
                                <td>채용공고 게시판</td>
                                <td>
                                    <a href="/web/board/edit_post.jsp?id=<%= rs.getInt("post_id") %>&boardType=admin">수정</a>
                                    <a href="../actions/delete_post_action.jsp?postId=<%= rs.getInt("post_id") %>&board_type=admin">삭제</a>
                                </td>
                            </tr>
                            <%
                        }
                        rs.close();
                        pstmt.close();
    
                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("데이터베이스 오류: " + e.getMessage());
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                }
            %>
        </table>
	    </div>
    <div>
    <h2>작성 댓글 조회</h2>
    <table border="1" class="table">
        <tr>
            <th>댓글 ID</th>
            <th>내용</th>
            <th>작성일</th>
            <th>수정일</th>
            <th>관리</th>
            <th>원글 조회</th>
        </tr>
        <%
            if (conn != null) {
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    String query = "SELECT c.comment_id, c.content, c.created_at, c.updated_at, p.title FROM user_comments c JOIN user_posts p ON c.post_id = p.post_id WHERE c.user_id = ?";
                    pstmt = conn.prepareStatement(query);
                    pstmt.setInt(1, userId);
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("comment_id") %></td>
            <td><%= rs.getString("content") %></td>
            <td><%= rs.getTimestamp("created_at") %></td>
            <td><%= rs.getTimestamp("updated_at") %></td>
            <td>
                <a href="edit_comment.jsp?id=<%= rs.getInt("comment_id") %>&board_type=user">수정</a>
                <a href="delete_comment.jsp?id=<%= rs.getInt("comment_id") %>&board_type=user">삭제</a>
            </td>
            <td><a href="web/board/post.jsp?id=<%= rs.getInt("post_id") %>&boardType=user">조회</a></td>
        </tr>
        <%
                    }
                    rs.close();
                    pstmt.close();
                    if (conn != null) {
                        String adminCommentQuery = "SELECT c.comment_id, c.content, c.created_at, c.updated_at, p.title FROM admin_comments c JOIN admin_posts p ON c.post_id = p.post_id WHERE c.user_id = ?";
                        pstmt = conn.prepareStatement(adminCommentQuery);
                        pstmt.setInt(1, userId);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("comment_id") %></td>
            <td><%= rs.getString("content") %></td>
            <td><%= rs.getTimestamp("created_at") %></td>
            <td><%= rs.getTimestamp("updated_at") %></td>
            <td>
                <a href="edit_comment.jsp?id=<%= rs.getInt("comment_id") %>&board_type=admin">수정</a>
                <a href="delete_comment.jsp?id=<%= rs.getInt("comment_id") %>&board_type=admin">삭제</a>
            </td>
	    <td><a href="web/board/post.jsp?id=<%= rs.getInt("post_id") %>&boardType=admin">조회</a></td>
	    </tr>
	    <%
                        }
                        rs.close();
                        pstmt.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("데이터베이스 오류: " + e.getMessage());
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        %>
    </table>
    </div>
    <div>
        <a href="/web/admin/userlists_dashboard.jsp" class="button">돌아가기</a>
    </div>
</div>
</body>
</html>
