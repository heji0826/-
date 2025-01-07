<%@ include file="../db/db_connection.jsp" %>
<%@ include file="../includes/md5.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = (String) session.getAttribute("username");
    String currentPassword = request.getParameter("current_password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String nickname = request.getParameter("nickname");
    String phone = request.getParameter("phone");
    String securityQuestion = request.getParameter("security_question");
    String securityAnswer = request.getParameter("security_answer");
    String newPassword = request.getParameter("password");

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String checkPasswordQuery = "SELECT password FROM users WHERE username = ?";
        pstmt = conn.prepareStatement(checkPasswordQuery);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String db_Password = rs.getString("password");
            if (!db_Password.equals(getMD5(currentPassword))) {
                out.println("<script>alert('현재 비밀번호가 잘못되었습니다.'); history.back();</script>");
                return;
            }
        } else {
            out.println("<script>alert('사용자를 찾을 수 없습니다.'); history.back();</script>");
            return;
        }
        // 비밀번호 규칙 검증: 최소 10자리, 3가지 종류 문자 조합
        if (!newPassword.matches("^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-={}\\[\\]:;'<>.,?]).{10,}$")) {
            throw new Exception("비밀번호는 최소 10자리 이상이어야 하며, 영문, 숫자, 특수문자 중 3가지 조합을 포함해야 합니다.");
        }        

        String query = "UPDATE users SET name = ?, email = ?, nickname = ?, phone = ?, security_question = ?, security_answer = ?";
        if (newPassword != null && !newPassword.isEmpty()) {
            query += ", password = ?";
        }
        query += " WHERE username = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, name);
        pstmt.setString(2, email);
        pstmt.setString(3, nickname);
        pstmt.setString(4, phone);
        pstmt.setString(5, securityQuestion);
        pstmt.setString(6, securityAnswer);
        if (newPassword != null && !newPassword.isEmpty()) {
            pstmt.setString(7, getMD5(newPassword));
            pstmt.setString(8, username);
        } else {
            pstmt.setString(7, username);
        }
        pstmt.executeUpdate();
        out.println("<script>alert('정보가 성공적으로 수정되었습니다.'); location.href='../profile.jsp';</script>");
    } catch (Exception e) {
        out.println("<script>alert('오류 발생: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>