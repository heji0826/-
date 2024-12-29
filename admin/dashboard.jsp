<%@ include file="includes/header.jsp" %>
<%@ include file="db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>관리자 페이지</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
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
        <table id="adminPostsTable">
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
                <!-- 데이터가 여기에 동적으로 추가됩니다 -->
            </tbody>
        </table>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // 예시 데이터 로드
            loadAdminPosts();

            // 폼 제출 이벤트 처리
            document.getElementById("adminPostForm").addEventListener("submit", function(event) {
                event.preventDefault();
                saveAdminPost();
            });
        });

        function loadAdminPosts() {
            // 서버에서 데이터를 받아오는 예제 (AJAX 요청)
            fetch('/api/admin_posts')
                .then(response => response.json())
                .then(data => {
                    const tableBody = document.getElementById('adminPostsTable').querySelector('tbody');
                    tableBody.innerHTML = '';
                    data.forEach(post => {
                        const row = document.createElement('tr');
                        row.innerHTML = `
                            <td>${post.post_id}</td>
                            <td>${post.title}</td>
                            <td>${post.content}</td>
                            <td>${post.attachment_path}</td>
                            <td>${post.created_at}</td>
                            <td>${post.updated_at}</td>
                            <td>
                                <button onclick="editAdminPost(${post.post_id})">수정</button>
                                <button onclick="deleteAdminPost(${post.post_id})">삭제</button>
                            </td>
                        `;
                        tableBody.appendChild(row);
                    });
                });
        }

        function saveAdminPost() {
            const postId = document.getElementById('adminPostId').value;
            const title = document.getElementById('adminPostTitle').value;
            const content = document.getElementById('adminPostContent').value;
            const attachmentPath = document.getElementById('adminPostAttachment').value;

            const postData = {
                title: title,
                content: content,
                attachment_path: attachmentPath
            };

            let url = '/api/admin_posts';
            let method = 'POST';

            if (postId) {
                url += `/${postId}`;
                method = 'PUT';
            }

            fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(postData)
            })
            .then(response => response.json())
            .then(data => {
                loadAdminPosts();
                document.getElementById('adminPostForm').reset();
            });
        }

        function editAdminPost(postId) {
            fetch(`/api/admin_posts/${postId}`)
                .then(response => response.json())
                .then(post => {
                    document.getElementById('adminPostId').value = post.post_id;
                    document.getElementById('adminPostTitle').value = post.title;
                    document.getElementById('adminPostContent').value = post.content;
                    document.getElementById('adminPostAttachment').value = post.attachment_path;
                });
        }

        function deleteAdminPost(postId) {
            fetch(`/api/admin_posts/${postId}`, {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(data => {
                loadAdminPosts();
            });
        }
    </script>
</body>
</html>
