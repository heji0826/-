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

    PreparedStatement pstmt = null;

    try {
        String query = "INSERT INTO users (name, username, password, email, nickname, phone, security_question, security_answer) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, name);
        pstmt.setString(2, username);
        pstmt.setString(3, getMD5(password));
        pstmt.setString(4, email);
        pstmt.setString(5, nickname);
        pstmt.setString(6, phone);
        pstmt.setString(7, securityQuestion);
        pstmt.setString(8, securityAnswer);
        pstmt.executeUpdate();

        response.sendRedirect("../login.jsp");
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>