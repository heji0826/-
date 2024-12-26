<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = (String) session.getAttribute("username");
    String content = request.getParameter("content");
    int postId = Integer.parseInt(request.getParameter("post_id"));
    String boardType = request.getParameter("board_type");

    String nickname = null;
    int userId = 0;
    PreparedStatement stmt = null;
    PreparedStatement nicknameStmt = null;
    ResultSet nicknameRs = null;
    PreparedStatement userStmt = null;
    ResultSet userRs = null;

    try {
        String nicknameQuery = "SELECT nickname, user_id FROM users WHERE username = ?";
        nicknameStmt = conn.prepareStatement(nicknameQuery);
        nicknameStmt.setString(1, username);
        nicknameRs = nicknameStmt.executeQuery();

        if (nicknameRs.next()) {
            nickname = nicknameRs.getString("nickname");
            userId = nicknameRs.getInt("user_id");
        }

        String userCheckQuery = "SELECT COUNT(*) FROM users WHERE user_id = ?";
        userStmt = conn.prepareStatement(userCheckQuery);
        userStmt.setInt(1, userId);
        userRs = userStmt.executeQuery();

        if (userRs.next() && userRs.getInt(1) > 0) {
            String query = "INSERT INTO comments (post_id, user_id, nickname, content, board_type) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, postId);
            stmt.setInt(2, userId);
            stmt.setString(3, nickname);
            stmt.setString(4, content);
            stmt.setString(5, boardType);
            stmt.executeUpdate();

            response.sendRedirect("../board/post.jsp?id=" + postId);
        } else {
            out.println("유효하지 않은 사용자입니다.");
        }
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (nicknameStmt != null) nicknameStmt.close();
        if (nicknameRs != null) nicknameRs.close();
        if (userStmt != null) userStmt.close();
        if (userRs != null) userRs.close();
        if (conn != null) conn.close();
    }
%>
