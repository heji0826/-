<%@ include file="../db/db_connection.jsp" %>
<%@ include file="../includes/md5.jsp" %>
<%@ page import="java.util.UUID" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String csrfToken = UUID.randomUUID().toString();

    PreparedStatement pstmt = null;
    ResultSet rs = null;
    final int MAX_ATTEMPTS = 5; // 허용 가능한 최대 로그인 시도 횟수
    final int LOCK_TIME = 15 * 60 * 1000; // 계정 잠금 시간 (15분)

    try {
        // 1. 로그인 시도 횟수와 마지막 시도 시간 확인
        String attemptQuery = "SELECT login_attempts, last_attempt FROM users WHERE username = ?";
        pstmt = conn.prepareStatement(attemptQuery);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            int loginAttempts = rs.getInt("login_attempts");
            Timestamp lastAttemptTimestamp = rs.getTimestamp("last_attempt");
        
            long lastAttempt = (lastAttemptTimestamp != null) ? lastAttemptTimestamp.getTime() : 0; // NULL 처리
            long currentTime = System.currentTimeMillis();
        
            // 잠금 상태 확인
            if (loginAttempts >= MAX_ATTEMPTS && (currentTime - lastAttempt) < LOCK_TIME) {
                out.println("<p>계정이 잠겼습니다. " + (LOCK_TIME / 60000) + "분 후에 다시 시도하세요.</p>");
                return;
            }
        }
        

        // 2. 로그인 시도
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, username);
        pstmt.setString(2, getMD5(password));
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // 로그인 성공
            int userId = rs.getInt("user_id");
            boolean isAdmin = rs.getBoolean("is_admin");

            // 로그인 시도 횟수 초기화
            String resetAttemptsQuery = "UPDATE users SET login_attempts = 0 WHERE username = ?";
            pstmt = conn.prepareStatement(resetAttemptsQuery);
            pstmt.setString(1, username);
            pstmt.executeUpdate();

            session.setAttribute("user_id", userId);
            session.setAttribute("username", username);
            session.setAttribute("is_admin", isAdmin);
            session.setAttribute("csrfToken", csrfToken);
            response.sendRedirect("../index.jsp");
        } else {
            // 로그인 실패
            String updateAttemptsQuery = "UPDATE users SET login_attempts = login_attempts + 1, last_attempt = NOW() WHERE username = ?";
            pstmt = conn.prepareStatement(updateAttemptsQuery);
            pstmt.setString(1, username);
            pstmt.executeUpdate();

            out.println("<p>로그인 실패! 아이디 또는 비밀번호를 확인하세요.</p>");
        }
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close(); // 연결 닫기
    }
%>
