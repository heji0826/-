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
                    <option value="" disabled selected>게시판을 선택해주세요.</option>
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
			            int postId = rs.getInt("post_id");

                        %>
                        <tr>
                            <td><%= rs.getInt("post_id") %></td>
                            <td><a href="../board/post.jsp?id=<%= rs.getInt("post_id") %>&boardType=<%= boardType %>"><%= rs.getString("title") %></a></td>
                            <td><%= rs.getString("content") %></td>
                            <td><%= rs.getString("attachment_path") %></td>
                            <td><%= rs.getTimestamp("created_at") %></td>
                            <td><%= rs.getTimestamp("updated_at") %></td>
                            <td>
                             <form id="editForm_<%= postId %>" action="../board/edit_post.jsp" method="post">
                                    <input type="hidden" name="id" value="<%= postId %>">
                                    <input type="hidden" name="boardType" value="<%= boardType %>">
                                    <button type="button" onclick="submitEditForm(<%= postId %>)">수정</button>
                                </form>
                                <script>
                                function submitEditForm(postId) {
                                    document.getElementById('editForm_' + postId).submit();
                                }
                                </script>

				<form id="deleteForm_<%= postId %>" action="../actions/delete_post_action.jsp" method="post" style="display: inline-block;">
    <input type="hidden" name="postId" value="<%= postId %>">
    <input type="hidden" name="boardType" value="<%= boardType %>">
    <button type="button" onclick="confirmDelete(<%= postId %>)">삭제</button>
</form>

<script>
function confirmDelete(postId) {
    if (confirm('정말 삭제하시겠습니까?')) {
        document.getElementById('deleteForm_' + postId).submit();
    }
}
</script>
                            </td>
                        </tr>
                        <%
                            }
                            rs.close();
                            stmt.close();
			    } else if(boardType == null){
			    %> 
				<tr>
					<td colspan="7">게시판을 선택해주세요.</td>
				</tr>
<%
			    }

			    else {
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
