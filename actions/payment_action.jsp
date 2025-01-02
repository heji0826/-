<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = (String) session.getAttribute("username");

    Statement stmt = null;

    try {
        String query = "UPDATE users SET is_vip = '1'";
        query += " WHERE username = '" + username + "'";

        stmt = conn.createStatement();
        stmt.executeUpdate(query);
        session.setAttribute("is_vip", true);
        response.sendRedirect("../board/vip_board.jsp");
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>