<%@ include file="../db/db_connection.jsp" %>
<%@ include file="../includes/md5.jsp" %>
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

    Statement stmt = null;

    try {
        String query = "INSERT INTO users (name, username, password, email, nickname, phone, security_question, security_answer) " +
                       "VALUES ('" + name + "', '" + username + "', '" + getMD5(password) + "', '" + email + "', '" + nickname + "', '" + phone + "', '" + securityQuestion + "', '" + securityAnswer + "')";
        stmt = conn.createStatement();
        stmt.executeUpdate(query);

        response.sendRedirect("../login.jsp");
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
