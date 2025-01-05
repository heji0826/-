<%@ include file="./dashboard.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../db/db_connection.jsp" %>
<%
    if (loggedInUserId == null) {
        response.sendRedirect("/web/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>공지사항 작성</title>
    <link rel="stylesheet" href="../css/style.css">
    <script>
        function updateBoardType() {
            var select = document.getElementById("boardType");
            var hiddenInput = document.getElementById("hiddenBoardType");
            hiddenInput.value = select.options[select.selectedIndex].value;
        }
    </script>
</head> 
<body>
            <!-- Admin Posts 관리 -->
            <div class="content">
                <h2>공지사항 작성</h2>
                <div class="admin-container">
                    <h3>새 공지사항 작성</h3>
                    <form action="../actions/write_post_action.jsp" method="post" enctype="multipart/form-data">
                        <label for="boardType">게시판 유형:</label>
                        <select id="boardType" name="boardType" onchange="updateBoardType()" required>
                            <option value="user">일반 회원 게시판</option>
                            <option value="admin">관리자 게시판</option>
                        </select><br>
                        <input type="hidden" id="hiddenBoardType" name="boardType" value="user">
                        <input type="text" id="title" name="title" placeholder="제목" required>
                        <textarea id="content" name="content" placeholder="내용" required></textarea>
                        <label for="attachment">첨부파일:</label>
                        <input type="file" id="attachment" name="attachment"><br>
                        <button type="submit" class="button">작성</button>
                    </form>
</body>
