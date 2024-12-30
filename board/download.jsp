<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page contentType="application/octet-stream" %>
<%
    String fileName = request.getParameter("file");
    if (fileName != null && !fileName.isEmpty()) {
        fileName = URLDecoder.decode(fileName, "UTF-8");
        String filePath = application.getRealPath("/uploads/") + fileName;
        log(filePath);
        File file = new File(filePath);

        if (file.exists() && file.isFile()) {
            response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(file.getName(), "UTF-8") + "\"");
            response.setContentType("application/octet-stream");
            response.setContentLengthLong(file.length());

            // 파일을 읽어서 클라이언트에게 전송
            try (BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));
                 BufferedOutputStream outStream = new BufferedOutputStream(response.getOutputStream())) {

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    outStream.write(buffer, 0, bytesRead);
                }
                outStream.flush();
            } catch (IOException e) {
                response.setContentType("text/html; charset=UTF-8");
                out.println("파일 다운로드 중 오류가 발생했습니다: " + e.getMessage());
            }
        } else {
            response.setContentType("text/html; charset=UTF-8");
            out.println("파일을 찾을 수 없거나 잘못된 요청입니다.");
        }
    } else {
        response.setContentType("text/html; charset=UTF-8");
        out.println("파일명이 제공되지 않았습니다.");
    }
%>
