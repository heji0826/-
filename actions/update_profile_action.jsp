<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = (String) session.getAttribute("username");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String nickname = request.getParameter("nickname");
    String phone = request.getParameter("phone");
    String securityQuestion = request.getParameter("security_question");
    String securityAnswer = request.getParameter("security_answer");
    String password = request.getParameter("password");

    PreparedStatement stmt = null;

    try {
        String query = "UPDATE users SET name = ?, email = ?, nickname = ?, phone = ?, security_question = ?, security_answer = ?"
                     + (password != null && !password.isEmpty() ? ", password = ?" : "")
                     + " WHERE username = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, name);
        stmt.setString(2, email);
        stmt.setString(3, nickname);
        stmt.setString(4, phone);
        stmt.setString(5, securityQuestion);
        stmt.setString(6, securityAnswer);
        if (password != null && !password.isEmpty()) {
            stmt.setString(7, password);
            stmt.setString(8, username);
        } else {
            stmt.setString(7, username);
        }
        stmt.executeUpdate();
        response.sendRedirect("../profile.jsp");
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
