<%@ page import="java.io.*" %>
<%@ page contentType="application/octet-stream" %>
<%
    String fileName = request.getParameter("file");
    if (fileName != null && !fileName.isEmpty()) {
        String filePath = application.getRealPath("/uploads/") + fileName;
        File file = new File(filePath);

        if (file.exists()) {
            response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
            response.setContentType("application/octet-stream");
            response.setContentLength((int) file.length());

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
                out.println("파일 다운로드 중 오류가 발생했습니다: " + e.getMessage());
            }
        } else {
            out.println("파일을 찾을 수 없습니다.");
        }
    } else {
        out.println("파일명이 제공되지 않았습니다.");
    }
%>
