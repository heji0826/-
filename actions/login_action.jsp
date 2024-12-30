<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Statement stmt = null;
    ResultSet rs = null;

    try {
        String query = "SELECT * FROM users WHERE username = '" + username + "' AND password = '" + password + "'";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);

        if (rs.next()) {
            int userId = rs.getInt("user_id");
            boolean isAdmin = rs.getBoolean("is_admin");
            session.setAttribute("user_id", userId);
            session.setAttribute("username", username);
            session.setAttribute("is_admin", isAdmin);
            response.sendRedirect("../index.jsp");
        } else {
            out.println("<p>로그인 실패! 아이디 또는 비밀번호를 확인하세요.</p>");
        }
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close(); // 연결 닫기
    }
%>
