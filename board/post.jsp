<%@ include file="../includes/header.jsp" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    int postId = Integer.parseInt(request.getParameter("id"));
    String boardType = request.getParameter("boardType");

    if (boardType == null) {
        boardType = "user"; // 기본값 설정
    }

    String query = boardType.equals("admin") 
        ? "SELECT u.user_id, ap.post_id, ap.title, ap.created_at, u.nickname, ap.content, ap.attachment_path " +
          "FROM admin_posts ap JOIN users u ON ap.user_id = u.user_id WHERE ap.post_id = " + postId
        : "SELECT u.user_id, up.post_id, up.title, up.created_at, u.nickname, up.content, up.attachment_path " +
          "FROM user_posts up JOIN users u ON up.user_id = u.user_id WHERE up.post_id = " + postId;

    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery(query);

    Integer loggedInUserId = (Integer) session.getAttribute("user_id");

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
    <style>
        
    </style>
    
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
                        <a href="<%= request.getContextPath() %>./download.jsp?file=<%= attachmentPath %>">
                            <%= attachmentPath %>
                        </a>
                    </p>
                <% } %>
                <% if (rs.getInt("user_id") == loggedInUserId || Boolean.TRUE.equals(isAdmin)) { %>
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
                <% } %>
            <% } %>
            <hr>
            <h3>댓글</h3>
            <form action="../actions/add_comment_action.jsp" method="post">
                <input type="hidden" name="post_id" value="<%= postId %>">
                <input type="hidden" name="board_type" value="<%= boardType %>">
                <textarea name="content" required></textarea><br>
                <button type="submit">댓글 달기</button>
            </form>
            <table class="comments-table">
                <thead>
                    <tr>
                        <th>작성자</th>
                        <th>내용</th>
                        <th>작성일</th>
                        <% if (isAdmin != null && isAdmin) { %>
                            <th>관리</th>
                        <% } %>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String commentQuery = boardType.equals("admin") 
                            ? "SELECT c.comment_id, c.content, c.created_at, u.nickname, c.user_id " +
                              "FROM admin_comments c JOIN users u ON c.user_id = u.user_id WHERE c.post_id = " + postId
                            : "SELECT c.comment_id, c.content, c.created_at, u.nickname, c.user_id " +
                              "FROM user_comments c JOIN users u ON c.user_id = u.user_id WHERE c.post_id = " + postId;
            
                        commentQuery += " ORDER BY c.created_at DESC";     
                        ResultSet commentRs = stmt.executeQuery(commentQuery);
            
                        while (commentRs.next()) {
                            int commentUserId = commentRs.getInt("user_id");
                    %>
                    <tr>
                        <td><%= commentRs.getString("nickname") %></td>
                        <td>
                            <% if ((Boolean.TRUE.equals(isAdmin)) || (loggedInUserId == commentUserId)) { %>
                                <form action="../actions/edit_comment_action.jsp" method="post" style="display:inline;" id="edit-form-<%= commentRs.getInt("comment_id") %>">
                                    <input type="hidden" name="comment_id" value="<%= commentRs.getInt("comment_id") %>">
                                    <input type="hidden" name="boardType" value="<%= boardType %>">
                                    
                                    <span id="comment-text-span-<%= commentRs.getInt("comment_id") %>"><%= commentRs.getString("content") %></span>
                                    <textarea name="content" id="comment-text-<%= commentRs.getInt("comment_id") %>" required style="display:none;" disabled><%= commentRs.getString("content") %></textarea>
                                    
                                    <button type="button" id="save-button-<%= commentRs.getInt("comment_id") %>" class="btn-save" onclick="saveEdit(<%= commentRs.getInt("comment_id") %>)" style="display:none;">완료</button>
                                </form>
                            <% } else { %>
                                <%= commentRs.getString("content") %>
                            <% } %>
                        </td>
                        <td><%= commentRs.getTimestamp("created_at") %></td>
                        <% 
                            if ((Boolean.TRUE.equals(isAdmin)) || loggedInUserId == commentUserId) { 
                        %>
                        <td>
                            <a href="javascript:void(0);" 
                               id="edit-button-<%= commentRs.getInt("comment_id") %>" 
                               data-comment-id="<%= commentRs.getInt("comment_id") %>"
                               data-board-type="<%= boardType %>"
                               class="btn-edit"
                               onclick="enableEdit(this)">
                                수정
                            </a>
                            <a href="../actions/delete_comment_action.jsp?id=<%= commentRs.getInt("comment_id") %>&boardType=<%= boardType %>" 
                               class="btn-edit"
                               onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                        </td>
                        <% } %>
                    </tr>
                    <%
                        }
                        commentRs.close();
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
<%
    rs.close();
    stmt.close();
%>
