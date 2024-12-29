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
    String fileName = null;
    int userId = 0;
    int postId = 0;

    // 게시판 종류 설정 (user 또는 admin)
    String boardType = request.getParameter("boardType");
    if (boardType == null) {
        boardType = "user";  // 기본값은 user로 설정
    }

    // 사용자 정보
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("/web/login.jsp");
        return;
    }

    // 사용자 ID 조회 (데이터베이스에서 user_id를 가져옴)
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        String query = "SELECT user_id FROM users WHERE username = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, username);
        rs = stmt.executeQuery();

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
        if (stmt != null) stmt.close();
        if (rs != null) rs.close();
    }

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
                    } else if ("postId".equals(item.getFieldName())) {
                        postId = Integer.parseInt(item.getString());
                    }
            } else {
                // attachment에 파일이 있나 확인
                if (item.getName() == null || item.getName().isEmpty()) {
                    continue;  // 파일이 없는 경우 다음 아이템으로 넘어감
                } else {
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
        }

        // 게시물 정보 DB에 수정
        String insertQuery = "";
        if(fileName == null) {
            if("admin".equals(boardType)) {
                insertQuery = "UPDATE admin_posts SET title = ?, content = ?, updated_at = ? WHERE post_id = ?";
            } else {
                insertQuery = "UPDATE user_posts SET title = ?, content = ?, updated_at = ? WHERE post_id = ?";
            }
        } else {
            if("admin".equals(boardType)) {
                insertQuery = "UPDATE admin_posts SET title = ?, content = ?, updated_at = ?, attachment_path = ? WHERE post_id = ?";
            } else {
                insertQuery = "UPDATE user_posts SET title = ?, content = ?, updated_at = ?, attachment_path = ? WHERE post_id = ?";
            }
        }
        // UPDATE 쿼리 실행
        PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
        insertStmt.setString(1, title); // title
        insertStmt.setString(2, content); // content
        insertStmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));  // updated_at
        if(fileName == null) {
            insertStmt.setInt(4, postId); // post_id
        }
        else {
            insertStmt.setString(4, fileName);  // 파일 경로 저장
            insertStmt.setInt(5, postId); // post_id
        }
        insertStmt.executeUpdate();

        // 게시물 등록 후 리디렉션
        if ("admin".equals(boardType)) {
            response.sendRedirect("/web/board/post.jsp?id=" + postId + "&boardType=" + boardType);
        } else {
            response.sendRedirect("/web/board/post.jsp?id=" + postId + "&boardType=" + boardType);
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
