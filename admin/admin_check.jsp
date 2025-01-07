<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    Integer loggedInUserId = (Integer) session.getAttribute("user_id");
    if (loggedInUserId == null) {
        response.sendRedirect("/web/login.jsp");
        return;
    }

    // 관리자 권한 확인
    boolean is_Admin = false;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String query = "SELECT is_admin FROM users WHERE user_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, loggedInUserId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            is_Admin = rs.getBoolean("is_admin");
        }

        // 관리자가 아닌 경우 로그인 페이지로 리디렉션
        if (!is_Admin) {
            response.sendRedirect("/web/login.jsp");
            return;
        }
    } catch (Exception e) {
        out.println("권한 확인 중 오류 발생: " + e.getMessage());
        return;
    } finally {
        // 자원 해제
        if (rs != null) try { rs.close(); } catch (Exception e) { }
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) { }
    }
%>