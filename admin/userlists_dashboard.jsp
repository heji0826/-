<%@ include file="../db/db_connection.jsp" %>
<%@ include file="./dashboard.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>회원 관리</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="content">
        <h1>회원 관리</h1>
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
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM users");
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
                    <a href="/web/actions/delete_user_action.jsp?username=<%= rs.getString("username") %>" class="button">삭제</a>
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
                    stmt.close();
                } else {
            %>
            <tr>
                <td colspan="7">데이터베이스 연결에 실패했습니다.</td>
            </tr>
            <%
                }
            %>
        </table>
    </div>
</body>
</html>
