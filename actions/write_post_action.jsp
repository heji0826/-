<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String title = null;
    String content = null;
    String nickname = null;
    String fileName = null;
    String boardType = "user";

    if ("admin".equals(session.getAttribute("role"))) {
        boardType = "admin";
    }

    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("/web/login.jsp");
        return;
    }

    // 사용자 닉네임 조회
    PreparedStatement nicknameStmt = conn.prepareStatement("SELECT nickname FROM users WHERE username = ?");
    nicknameStmt.setString(1, username);
    ResultSet nicknameRs = nicknameStmt.executeQuery();
    if (nicknameRs.next()) {
        nickname = nicknameRs.getString("nickname");
    }
    nicknameRs.close();
    nicknameStmt.close();

    // 파일 업로드를 위한 설정
    DiskFileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(factory);

    try {
        // 파일 업로드 처리
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
                File uploadDir = new File(getServletContext().getRealPath("/") + "uploads/");
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                File uploadedFile = new File(uploadDir + fileName);
                item.write(uploadedFile);

                // 디버깅: 업로드된 파일 경로 출력
                out.println("업로드 디렉토리 경로: " + uploadedFile.getAbsolutePath());
            }
        }

        // 게시물 정보 DB에 삽입
        Integer userId = (Integer) session.getAttribute("user_id");

        // INSERT 쿼리
        PreparedStatement stmt = conn.prepareStatement("INSERT INTO " + boardType + "_posts (title, content, attachment_path, created_at, updated_at, user_id, nickname) VALUES (?, ?, ?, ?, ?, ?, ?)");
        stmt.setString(1, title);
        stmt.setString(2, content);
        stmt.setString(3, fileName);  // 파일 이름만 삽입
        stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));  // created_at
        stmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));  // updated_at
        stmt.setInt(6, userId);  // user_id
        stmt.setString(7, nickname);  // nickname
        stmt.executeUpdate();

        // 게시물 등록 후 리디렉션
        if ("admin".equals(boardType)) {
            response.sendRedirect("admin_board.jsp");
        } else {
            response.sendRedirect("user_board.jsp");
        }
    } catch (Exception e) {
        // 디버깅
        out.println("업로드 디렉토리 경로: " + e.getMessage());
        log("파일 업로드 또는 DB 처리 중 오류 발생: " + e.getMessage());
        out.println("파일 업로드 또는 게시물 등록에 실패했습니다.");
    }
%>
