<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    int commentId = Integer.parseInt(request.getParameter("id"));

    try {
        PreparedStatement stmt = conn.prepareStatement("DELETE FROM user_comments WHERE comment_id = ?");
        stmt.setInt(1, commentId);
        stmt.executeUpdate();
        
        // 댓글 삭제 후 리디렉션
        response.sendRedirect(request.getHeader("Referer"));
    } catch (Exception e) {
        e.printStackTrace();
        out.println("삭제 중 오류가 발생했습니다.");
    } finally {
        if (conn != null) conn.close();
    }
%>
