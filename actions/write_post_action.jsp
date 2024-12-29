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
<%
    request.setCharacterEncoding("UTF-8");

    // 폼 값들
    String title = null;
    String content = null;
    String nickname = null;
    String fileName = null;

    // 게시판 종류 설정 (user 또는 admin)
    String boardType = request.getParameter("boardType");  // user_board.jsp 또는 admin_board.jsp에서 전달된 값
    if (boardType == null) {
        boardType = "user";  // 기본값은 user로 설정
    }

    // 사용자 정보
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
                // 파일이 있을 경우 파일 처리
                fileName = new File(item.getName()).getName();
                File uploadDir = new File(getServletContext().getRealPath("/") + "uploads/");
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                File uploadedFile = new File(uploadDir + "/" + fileName);
                item.write(uploadedFile);  // 파일 업로드

                // 디버깅: 업로드된 파일 경로 출력
                log("업로드 디렉토리 경로: " + uploadedFile.getAbsolutePath());
            }
        }

        // 게시물 정보 DB에 삽입
        Integer userId = (Integer) session.getAttribute("user_id");

        // 게시판 종류에 맞는 테이블에 삽입 (user_posts 또는 admin_posts)
        String insertQuery = "";
        if ("admin".equals(boardType)) {
            insertQuery = "INSERT INTO admin_posts (title, content, attachment_path, created_at, updated_at, user_id, nickname) VALUES (?, ?, ?, ?, ?, ?, ?)";
        } else {
            insertQuery = "INSERT INTO user_posts (title, content, attachment_path, created_at, updated_at, user_id, nickname) VALUES (?, ?, ?, ?, ?, ?, ?)";
        }

        // INSERT 쿼리 실행
        PreparedStatement stmt = conn.prepareStatement(insertQuery);
        stmt.setString(1, title);
        stmt.setString(2, content);
        stmt.setString(3, fileName);  // 파일 경로 저장
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
        // 예외 처리
        log("파일 업로드 또는 게시물 등록에 실패했습니다. 오류: " + e.getMessage());

        // 스택 트레이스 문자열로 변환
        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw));
        String stackTrace = sw.toString();
        
        out.println("파일 업로드 또는 게시물 등록에 실패했습니다. 오류 스택 트레이스:");
        out.println(stackTrace);  // 자세한 오류 정보 출력
    }
%>
