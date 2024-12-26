<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("name");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String email = request.getParameter("email");
    String nickname = request.getParameter("nickname");
    String phone = request.getParameter("phone");
    String securityQuestion = request.getParameter("security_question");
    String securityAnswer = request.getParameter("security_answer");

    PreparedStatement stmt = null;

    try {
        String query = "INSERT INTO users (name, username, password, email, nickname, phone, security_question, security_answer) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, name);
        stmt.setString(2, username);
        stmt.setString(3, password);
        stmt.setString(4, email);
        stmt.setString(5, nickname);
        stmt.setString(6, phone);
        stmt.setString(7, securityQuestion);
        stmt.setString(8, securityAnswer);
        stmt.executeUpdate();

        response.sendRedirect("../login.jsp");
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
