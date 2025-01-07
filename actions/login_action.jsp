<%@ include file="../db/db_connection.jsp" %>
<%@ include file="../includes/md5.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Log4j2 연동을 위한 logger 생성
    org.apache.logging.log4j.Logger logger = org.apache.logging.log4j.LogManager.getLogger("LoginAction");

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, username);
        pstmt.setString(2, getMD5(password));
        rs = pstmt.executeQuery();

        if (rs.next()) {
            int userId = rs.getInt("user_id");
            boolean isAdmin = rs.getBoolean("is_admin");
            session.setAttribute("user_id", userId);
            session.setAttribute("username", username);
            session.setAttribute("is_admin", isAdmin);
            response.sendRedirect("../index.jsp");
        } else {
            // 로그인 실패 시 취약한 로그 출력
            logger.error(username);  // 취약한 코드: 유저명 로그 기록
            out.println("<p>로그인 실패! 아이디 또는 비밀번호를 확인하세요.</p>");
        }
    } catch (Exception e) {
        // 예외 처리 시에도 로그 기록
        logger.error("Error occurred during login attempt", e);  // 예외 로그 기록
        out.println("에러: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close(); // 연결 닫기
    }
%>