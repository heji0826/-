<%@ include file="includes/header.jsp" %>
<%@ include file="db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String usernameFromSession = (String) session.getAttribute("username");
    if (usernameFromSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Statement stmt = conn.createStatement();
    String query = "SELECT * FROM users WHERE username = '" + usernameFromSession + "'";
    ResultSet rs = stmt.executeQuery(query);
%>
<!DOCTYPE html>
<html>
<head>
    <title>내 정보 수정</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="layout">
    <div class="main-content">
        <div class="container">
            <h1>내 정보 수정</h1>
            <%
                if (rs.next()) {
            %>
            <form action="actions/update_profile_action.jsp" method="post" accept-charset="UTF-8">
                <label for="name">이름:</label>
                <input type="text" id="name" name="name" value="<%= rs.getString("name") %>" required><br>

                <label for="email">이메일:</label>
                <input type="email" id="email" name="email" value="<%= rs.getString("email") %>" required><br>

                <label for="nickname">닉네임:</label>
                <input type="text" id="nickname" name="nickname" value="<%= rs.getString("nickname") %>" required><br>

                <label for="phone">휴대폰 번호:</label>
                <input type="text" id="phone" name="phone" value="<%= rs.getString("phone") %>" required><br>

                <label for="security_question">비밀번호 질문:</label>
                <select id="security_question" name="security_question" required>
                    <option value="treasure" <%= rs.getString("security_question").equals("treasure") ? "selected" : "" %>>내가 아끼는 보물 1호는?</option>
                    <option value="birthplace" <%= rs.getString("security_question").equals("birthplace") ? "selected" : "" %>>내가 태어난 곳은?</option>
                </select><br>

                <label for="security_answer">답변:</label>
                <input type="text" id="security_answer" name="security_answer" value="<%= rs.getString("security_answer") %>" required><br>

                <label for="password">새 비밀번호:</label>
                <input type="password" id="password" name="password" placeholder="새 비밀번호 (변경하지 않으려면 비워둡니다)"><br>

                <label for="current_password">현재 비밀번호:</label>
                <input type="password" id="current_password" name="current_password" placeholder="현재 비밀번호" required><br>

                <button type="submit" class="button">수정하기</button>
            </form>
            <% } else { %>
                <script>
                    alert("사용자 정보를 불러올 수 없습니다.");
                    window.location.href = "login.jsp";
                </script>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>
<%
    rs.close();
    stmt.close();
%>
