<%@ include file="../db/db_connection.jsp" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

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
            String user_name = rs.getString("username");
            String pass_word = rs.getString("password");
            response.sendRedirect("../find_password.jsp?user_name=" + URLEncoder.encode(user_name, "UTF-8") + "&pass_word=" + URLEncoder.encode(pass_word, "UTF-8"));
            response.sendRedirect("../find_password.jsp");
        } else {
            response.sendRedirect("../forgot_password_error.jsp");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("에러: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
