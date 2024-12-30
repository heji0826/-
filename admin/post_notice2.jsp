<%@ include file="../includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../db/db_connection.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>공지사항 작성</title>
    <link rel="stylesheet" href="../css/style.css">
    <script>
        function submitForm() {
            var form = document.getElementById("postForm");
            var boardType = docuemnt.getElementById("boardType").value;
            form.action = "../actions/write_post_action.jsp?boardType=" + boardType;
            form.submit();
            }
    </script>
</head> 
<body>
            <!-- Admin Posts 관리 -->
            <div class="content">
                <h2>공지사항 작성</h2>
                <div class="container">
                    <h3>새 공지사항 작성</h3>
                    <form id="postForm" method="post" enctype="multipart/form-data">
                        <label for="boardType">게시판 유형:</label>
                        <select id="boardType" name="board_type" required>
                            <option value="user">일반 회원 게시판</option>
                            <option value="admin">관리자 게시판</option>
                        </select><br>
                        <input type="text" id="title" name="title" placeholder="제목" required>
                        <textarea id="content" name="content" placeholder="내용" required></textarea>
                        <label for="attachment">첨부파일:</label>
                        <input type="file" id="attachment" name="attachment"><br>
                        <button type="submit" class="button">작성</button>
                    </form>
</body>
