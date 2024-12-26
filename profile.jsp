<%@ include file="includes/header.jsp" %>
<%@ include file="db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // session에서 username 가져오기
    String usernameFromSession = (String) session.getAttribute("username");
    if (usernameFromSession == null) {
        response.sendRedirect("login.jsp");
        return; // 이후 코드를 실행하지 않음
    }

    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE username = ?");
    stmt.setString(1, usernameFromSession);
    ResultSet rs = stmt.executeQuery();
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
                
                <label for="password">비밀번호:</label>
                <input type="password" id="password" name="password" placeholder="새 비밀번호 (변경하지 않으려면 비워둡니다)"><br>
                
                <button type="submit" class="button">수정하기</button>
            </form>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>
