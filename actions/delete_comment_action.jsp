<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    int commentId = Integer.parseInt(request.getParameter("id"));
    String boardType = request.getParameter("boardType");

    String commentTable = "user_comments";
    if ("admin".equals(boardType)) {
        commentTable = "admin_comments";
    }

    try {
        Statement stmt = conn.createStatement();
        String query = "DELETE FROM " + commentTable + " WHERE comment_id = " + commentId;
        stmt.executeUpdate(query);
        
        // 댓글 삭제 후 리디렉션
        response.sendRedirect(request.getHeader("Referer"));
    } catch (Exception e) {
        e.printStackTrace();
        out.println("삭제 중 오류가 발생했습니다.");
    } finally {
        if (conn != null) conn.close();
    }
%>
