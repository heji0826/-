<%@ page import="java.sql.*" %>
<%
    String dbURL = "jdbc:mysql://localhost:3306/mywebapp?useUnicode=true&characterEncoding=UTF-8";
    String dbUser = "myuser"; // 생성한 사용자 이름
    String dbPassword = "mypassword"; // 생성한 사용자 비밀번호
    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL JDBC 드라이버 로드
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    } catch (Exception e) {
        out.println("DB 연결 실패: " + e.getMessage());
    }
%>
