<%@ include file="../db/db_connection.jsp" %>
<%@ include file="../includes/md5.jsp" %>
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

    Statement stmt = null;

    try {
        String query = "UPDATE users SET name = '" + name + 
                       "', email = '" + email + 
                       "', nickname = '" + nickname + 
                       "', phone = '" + phone + 
                       "', security_question = '" + securityQuestion + 
                       "', security_answer = '" + securityAnswer + "'";
        if (password != null && !password.isEmpty()) {
            query += ", password = '" + getMD5(password) + "'";
        }
        query += " WHERE username = '" + username + "'";

        stmt = conn.createStatement();
        stmt.executeUpdate(query);
        response.sendRedirect("../profile.jsp");
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
