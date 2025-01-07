<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Arrays, java.util.List" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 폼 값들
    String title = null;
    String content = null;
    String fileName = null;
    int userId = 0;

    // 게시판 종류 설정 (user 또는 admin 또는 vip)
    String boardType = "user";

    // 사용자 정보
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("/web/login.jsp");
        return;
    }

    // 사용자 ID 조회 (데이터베이스에서 user_id를 가져옴)
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        String query = "SELECT user_id FROM users WHERE username = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            userId = rs.getInt("user_id");
        } else {
            response.sendRedirect("/web/login.jsp");
            return;
        }
    } catch (Exception e) {
        out.println("사용자 정보 조회 오류: " + e.getMessage());
        return;
    } finally {
        if (pstmt != null) pstmt.close();
        if (rs != null) rs.close();
    }

    // 파일 업로드를 위한 설정
    DiskFileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(factory);

    // 허용할 파일 확장자 목록
    List<String> allowedExtensions = Arrays.asList("jpg", "jpeg", "png", "gif", "pdf", "docx", "xlsx");

    try {
        // 파일 업로드 처리
        List<FileItem> items = upload.parseRequest(request);
        for (FileItem item : items) {
            if (item.isFormField()) {
                if ("title".equals(item.getFieldName())) {
                    title = item.getString("UTF-8");
                } else if ("content".equals(item.getFieldName())) {
                    content = item.getString("UTF-8");
                } else if ("boardType".equals(item.getFieldName())) {
                    boardType = item.getString("UTF-8");
                }
            } else {
                // attachment에 파일이 있나 확인
                if (item.getName() == null || item.getName().isEmpty()) {
                    continue;  // 파일이 없는 경우 다음 아이템으로 넘어감
                } else {
                    fileName = new File(item.getName()).getName();
                    String fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

                    if (!allowedExtensions.contains(fileExtension)) {
                        throw new Exception("허용되지 않은 파일 형식입니다: " + fileExtension);
                    }

                    File uploadDir = new File(getServletContext().getRealPath("/") + "uploads/");
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    File uploadedFile = new File(uploadDir + "/" + fileName);
                    item.write(uploadedFile);  // 파일 업로드
                }
            }
        }

        // 게시물 정보 DB에 삽입
        String insertQuery = "";
        if ("admin".equals(boardType)) {
            insertQuery = "INSERT INTO admin_posts (title, content, attachment_path, created_at, updated_at, user_id) VALUES (?, ?, ?, NOW(), NOW(), ?)";
        } else if ("user".equals(boardType)) {
            insertQuery = "INSERT INTO user_posts (title, content, attachment_path, created_at, updated_at, user_id) VALUES (?, ?, ?, NOW(), NOW(), ?)";
        } else {
            insertQuery = "INSERT INTO vip_posts (title, content, attachment_path, created_at, updated_at, user_id) VALUES (?, ?, ?, NOW(), NOW(), ?)";
        }

        // INSERT 쿼리 실행
        pstmt = conn.prepareStatement(insertQuery);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setString(3, fileName);
        pstmt.setInt(4, userId);
        pstmt.executeUpdate();

        // 게시물 등록 후 리디렉션
        if ("admin".equals(boardType)) {
            response.sendRedirect("/web/board/admin_board.jsp");
        } else if ("user".equals(boardType)) {
            response.sendRedirect("/web/board/user_board.jsp");
        } else {
            response.sendRedirect("/web/board/vip_board.jsp");
        }
    } catch (Exception e) {
        out.println("파일 업로드 또는 게시물 등록에 실패했습니다. 오류: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>