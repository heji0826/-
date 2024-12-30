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
        query = "SELECT u.user_id, ap.post_id, ap.title, ap.created_at, u.nickname, ap.content, ap.attachment_path " + 
                "FROM admin_posts ap " +
                "JOIN users u ON ap.user_id = u.user_id " + 
                "WHERE ap.post_id = ?";
    } else {
        query = "SELECT u.user_id, up.post_id, up.title, up.created_at, u.nickname, up.content, up.attachment_path " + 
                "FROM user_posts up " + 
                "JOIN users u ON up.user_id = u.user_id " + 
                "WHERE up.post_id = ?";
    }

    PreparedStatement stmt = conn.prepareStatement(query);
    stmt.setInt(1, postId);
    ResultSet rs = stmt.executeQuery();
    
    // 세션에서 user_id 가져오기
    Integer loggedInUserId = (Integer) session.getAttribute("user_id");

    // 로그인 상태가 아니라면 로그인 페이지로 리디렉션
    if (loggedInUserId == null) {
        response.sendRedirect("/web/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시물 상세보기</title>
    <link rel="stylesheet" href="../css/style.css">
    <script>
        function enableEdit(button) {
            var commentId = button.getAttribute("data-comment-id");
            var textarea = document.getElementById('comment-text-' + commentId);
            var editButton = document.getElementById('edit-button-' + commentId);
            var saveButton = document.getElementById('save-button-' + commentId);
            var contentSpan = document.getElementById('comment-text-span-' + commentId);

            contentSpan.style.display = 'none';

            // 수정폼 활성화
            textarea.style.display = 'block'; 
            textarea.disabled = false;
            editButton.style.display = 'none';
            saveButton.style.display = 'inline-block';
        }

        function saveEdit(commentId) {
            var textarea = document.getElementById('comment-text-' + commentId);
            var form = document.getElementById('edit-form-' + commentId);
            form.submit();
        }
    </script>
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
                        <a href="<%= request.getContextPath() %>./download.jsp?file=<%= attachmentPath %>">
                            <%= attachmentPath %>
                        </a>
                    </p>
                <% } %>
            <% } %>
            <%
                int userId = 0;
                if (username != null) {
                    PreparedStatement userStmt = conn.prepareStatement("SELECT user_id FROM users WHERE username = ?");
                    userStmt.setString(1, username);
                    ResultSet userRs = userStmt.executeQuery();
                    if (userRs.next()) {
                        userId = userRs.getInt("user_id");
                    }
                    userRs.close();
                    userStmt.close();
                }

                    // rs에서 가져온 user_id와 userId가 같으면 수정, 삭제 버튼을 보여줌
                    if (rs.getInt("user_id") == userId) {
                %>
                    <form action="../board/edit_post.jsp" method="post" style="display: inline-block; margin-right: 10px;">
                        <input type="hidden" name="id" value="<%= postId %>">
                        <input type="hidden" name="boardType" value="<%= boardType %>">
                        <button type="submit">수정</button>
                    </form>
                    <form action="../actions/delete_post_action.jsp" method="post" style="display: inline-block;">
                        <input type="hidden" name="postId" value="<%= postId %>">
                        <input type="hidden" name="boardType" value="<%= boardType %>">
                        <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                    </form>
            <%
                }
            %>

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
                    
                    PreparedStatement commentStmt = conn.prepareStatement("SELECT c.comment_id, c.content, c.created_at, u.nickname, c.user_id " + 
                                                                          "FROM " + commentTable + " c " + 
                                                                          "JOIN users u ON c.user_id = u.user_id " +
                                                                          "WHERE c.post_id = ?");
                    commentStmt.setInt(1, postId);
                    ResultSet commentRs = commentStmt.executeQuery();
                    while (commentRs.next()) {
                        int commentUserId = commentRs.getInt("user_id");
                %>
                <tr>
                    <td><%= commentRs.getString("nickname") %></td>
                    <td>
                        <% if ("admin".equals(session.getAttribute("role")) || loggedInUserId == commentUserId) { %>
                            <form action="../actions/edit_comment_action.jsp" method="post" style="display:inline;" id="edit-form-<%= commentRs.getInt("comment_id") %>">
                                <input type="hidden" name="comment_id" value="<%= commentRs.getInt("comment_id") %>">
                                <span id="comment-text-span-<%= commentRs.getInt("comment_id") %>"><%= commentRs.getString("content") %></span>
                                <textarea name="content" id="comment-text-<%= commentRs.getInt("comment_id") %>" required style="display:none;" disabled><%= commentRs.getString("content") %></textarea>
                                <button type="button" id="save-button-<%= commentRs.getInt("comment_id") %>" onclick="saveEdit(<%= commentRs.getInt("comment_id") %>)" style="display:none;">완료</button>
                            </form>
                        <% } else { %>
                            <%= commentRs.getString("content") %>
                        <% } %>
                    </td>
                    <td><%= commentRs.getTimestamp("created_at") %></td>
                    <% 
                        if ("admin".equals(session.getAttribute("role")) || loggedInUserId == commentUserId) { 
                    %>
                    <td>
                        <a href="javascript:void(0);" id="edit-button-<%= commentRs.getInt("comment_id") %>" 
                            data-comment-id="<%= commentRs.getInt("comment_id") %>"
                            onclick="enableEdit(this)">수정</a>
                    </td>
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
