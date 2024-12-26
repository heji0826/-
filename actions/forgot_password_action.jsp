<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = request.getParameter("username");
    String securityQuestion = request.getParameter("security_question");
    String securityAnswer = request.getParameter("security_answer");

    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        String query = "SELECT username, password FROM users WHERE username = ? AND security_question = ? AND security_answer = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, username);
        stmt.setString(2, securityQuestion);
        stmt.setString(3, securityAnswer);
        rs = stmt.executeQuery();

        if (rs.next()) {
            out.println("<p>아이디: " + rs.getString("username") + "</p>");
            out.println("<p>비밀번호: " + rs.getString("password") + "</p>");
        } else {
            out.println("<p>입력한 정보가 일치하지 않습니다.</p>");
        }
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
