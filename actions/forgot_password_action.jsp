<%@ include file="../db/db_connection.jsp" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String username = request.getParameter("username");
    String securityQuestion = request.getParameter("security_question");
    String securityAnswer = request.getParameter("security_answer");

    Statement stmt = null;
    ResultSet rs = null;

    try {
        String query = "SELECT username, password FROM users WHERE username = '" + username + 
                       "' AND security_question = '" + securityQuestion + 
                       "' AND security_answer = '" + securityAnswer + "'";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);

        if (rs.next()) {
            String user_name = rs.getString("username");
            String pass_word = rs.getString("password");
            response.sendRedirect("../find_password.jsp?user_name=" + URLEncoder.encode(user_name, "UTF-8") + "&pass_word=" + URLEncoder.encode(pass_word, "UTF-8"));
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
