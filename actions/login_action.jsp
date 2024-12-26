<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, username);
        stmt.setString(2, password);
        rs = stmt.executeQuery();

        if (rs.next()) {
            session.setAttribute("username", username);
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
