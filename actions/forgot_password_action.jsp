<%@ include file="../db/db_connection.jsp" %>
<%@ include file="../includes/md5.jsp" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
    // 랜덤 비밀번호 생성
    public static String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder password = new StringBuilder();
        for (int i = 0; i < 8; i++) { // 8자리 비밀번호
            int randomIndex = (int) (Math.random() * chars.length());
            password.append(chars.charAt(randomIndex));
        }
        return password.toString();
    }
%>

<%
    request.setCharacterEncoding("UTF-8");

    String username = request.getParameter("username");
    String securityQuestion = request.getParameter("security_question");
    String securityAnswer = request.getParameter("security_answer");

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 사용자 정보 검증
        String query = "SELECT username FROM users WHERE username = ? AND security_question = ? AND security_answer = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, username);
        pstmt.setString(2, securityQuestion);
        pstmt.setString(3, securityAnswer);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // 랜덤 비밀번호 생성
            String newPassword = generateRandomPassword();

            String updateQuery = "UPDATE users SET password = ? WHERE username = ?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, getMD5(newPassword));
            pstmt.setString(2, username);
            pstmt.executeUpdate();

            response.sendRedirect("../find_password.jsp?user_name=" + URLEncoder.encode(username, "UTF-8") + "&new_password=" + URLEncoder.encode(newPassword, "UTF-8"));
        } else {
            response.sendRedirect("../forgot_password_error.jsp");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("에러: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>