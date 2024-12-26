<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String dbURL = "jdbc:mysql://localhost:3306/mywebapp?useUnicode=true&characterEncoding=UTF-8";
    String dbUser = "myuser"; // MySQL 사용자 이름
    String dbPassword = "mypassword"; // MySQL 비밀번호
    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // JDBC 드라이버 로드
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword); // 데이터베이스 연결
        out.println("DB 연결 성공!<br>");

        // SQL 쿼리 실행
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM user_posts");

        // 결과 출력
        while (rs.next()) {
            out.println("ID: " + rs.getInt("post_id") + ", 제목: " + rs.getString("title") + "<br>");
        }
    } catch (Exception e) {
        out.println("DB 연결 실패: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (conn != null) conn.close();
    }
%>
