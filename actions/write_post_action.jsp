<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String title = null;
    String content = null;
    String nickname = null; // nickname을 따로 가져옴
    String fileName = null;
    String boardType = "user";

    if ("admin".equals(session.getAttribute("role"))) {
        boardType = "admin";
    }

    String username = (String) session.getAttribute("username");
    
    PreparedStatement nicknameStmt = conn.prepareStatement("SELECT nickname FROM users WHERE username = ?");
    nicknameStmt.setString(1, username);
    ResultSet nicknameRs = nicknameStmt.executeQuery();
    if (nicknameRs.next()) {
        nickname = nicknameRs.getString("nickname");
    }
    nicknameRs.close();
    nicknameStmt.close();

    DiskFileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(factory);

    try {
        List<FileItem> items = upload.parseRequest(request);
        for (FileItem item : items) {
            if (item.isFormField()) {
                if ("title".equals(item.getFieldName())) {
                    title = item.getString("UTF-8");
                } else if ("content".equals(item.getFieldName())) {
                    content = item.getString("UTF-8");
                }
            } else {
                fileName = new File(item.getName()).getName();
                File uploadedFile = new File(getServletContext().getRealPath("/") + "uploads/" + fileName);
                item.write(uploadedFile);
            }
        }

        PreparedStatement stmt = conn.prepareStatement("INSERT INTO " + boardType + "_posts (title, content, nickname, attachment) VALUES (?, ?, ?, ?)");
        stmt.setString(1, title);
        stmt.setString(2, content);
        stmt.setString(3, nickname);
        stmt.setString(4, fileName);
        stmt.executeUpdate();

        if ("admin".equals(boardType)) {
            response.sendRedirect("admin_board.jsp");
        } else {
            response.sendRedirect("user_board.jsp");
        }
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    }
%>
