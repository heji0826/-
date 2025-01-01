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

    Statement stmt = null;
    ResultSet rs = null;

    try {
        // 사용자 정보 검증
        String query = "SELECT username FROM users WHERE username = '" + username + 
                       "' AND security_question = '" + securityQuestion + 
                       "' AND security_answer = '" + securityAnswer + "'";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);

        if (rs.next()) {
            // 랜덤 비밀번호 생성
            String newPassword = generateRandomPassword();

            String updateQuery = "UPDATE users SET password = '" + getMD5(newPassword) + "' WHERE username = '" + username + "'";
            stmt.executeUpdate(updateQuery);

            response.sendRedirect("../find_password.jsp?user_name=" + URLEncoder.encode(username, "UTF-8") + "&new_password=" + URLEncoder.encode(newPassword, "UTF-8"));
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
