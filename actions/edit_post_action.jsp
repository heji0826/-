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

    String title = null;
    String content = null;
    String fileName = null;
    int userId = 0;
    int postId = 0;

    String boardType = "user";

    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("/web/login.jsp");
        return;
    }

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
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
    }

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
                } else if ("postId".equals(item.getFieldName())) {
                    postId = Integer.parseInt(item.getString());
                } else if ("boardType".equals(item.getFieldName())) {
                    boardType = item.getString();
                }
            } else {
                if (item.getName() == null || item.getName().isEmpty()) {
                    continue;
                } else {
                    fileName = new File(item.getName()).getName();
                    File uploadDir = new File(getServletContext().getRealPath("/") + "uploads/");
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    File uploadedFile = new File(uploadDir + "/" + fileName);
                    item.write(uploadedFile);
                    log("업로드 디렉토리 경로: " + uploadedFile.getAbsolutePath());
                }
            }
        }

        String updateQuery;
        if (fileName == null) {
            if ("admin".equals(boardType)) {
                updateQuery = "UPDATE admin_posts SET title = ?, content = ?, updated_at = NOW() WHERE post_id = ?";
            } else if("vip".equals(boardType)) {
                updateQuery = "UPDATE vip_posts SET title = ?, content = ?, updated_at = NOW() WHERE post_id = ?";
            } else {
                updateQuery = "UPDATE user_posts SET title = ?, content = ?, updated_at = NOW() WHERE post_id = ?";
            }
        } else {
            if ("admin".equals(boardType)) {
                updateQuery = "UPDATE admin_posts SET title = ?, content = ?, updated_at = NOW(), attachment_path = ? WHERE post_id = ?";
            } else if("vip".equals(boardType)) {
                updateQuery = "UPDATE vip_posts SET title = ?, content = ?, updated_at = NOW(), attachment_path = ? WHERE post_id = ?";
            } else {
                updateQuery = "UPDATE user_posts SET title = ?, content = ?, updated_at = NOW(), attachment_path = ? WHERE post_id = ?";
            }
        }

        pstmt = conn.prepareStatement(updateQuery);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        if (fileName == null) {
            pstmt.setInt(3, postId);
        } else {
            pstmt.setString(3, fileName);
            pstmt.setInt(4, postId);
        }
        pstmt.executeUpdate();

        response.sendRedirect("/web/board/post.jsp?id=" + postId + "&boardType=" + boardType);
    } catch (Exception e) {
        log("파일 업로드 또는 게시물 등록에 실패했습니다. 오류: " + e.getMessage());

        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw));
        String stackTrace = sw.toString();

        out.println("파일 업로드 또는 게시물 등록에 실패했습니다. 오류 스택 트레이스:");
        out.println(stackTrace);
    } finally {
        if (pstmt != null) pstmt.close();
    }
%>