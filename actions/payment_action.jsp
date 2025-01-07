<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = (String) session.getAttribute("username");

    PreparedStatement pstmt = null;

    try {
        String query = "UPDATE users SET is_vip = '1' WHERE username = ?";

        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, username);
        pstmt.executeUpdate();
        session.setAttribute("is_vip", true);
        response.sendRedirect("../board/vip_board.jsp");
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>