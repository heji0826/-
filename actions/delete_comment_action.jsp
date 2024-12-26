<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    int commentId = Integer.parseInt(request.getParameter("id"));

    PreparedStatement stmt = null;

    try {
        String query = "DELETE FROM comments WHERE id = ?";
        stmt = conn.prepareStatement(query);
        stmt.setInt(1, commentId);
        stmt.executeUpdate();

        response.sendRedirect(request.getHeader("Referer"));
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
