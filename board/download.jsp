<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page contentType="application/octet-stream" %>
<%
    String fileName = request.getParameter("file");

    if (fileName != null && !fileName.isEmpty()) {
        // 파일명 디코딩
        fileName = URLDecoder.decode(fileName, "UTF-8");

        // 다운로드 허용 디렉터리 설정 (화이트리스트)
        String allowedDir = application.getRealPath("/uploads/");
        log(allowedDir);

        // 다운로드 파일의 전체 경로 생성
        File file = new File(allowedDir, fileName);

        // 경로 조작 방지: 파일이 허용된 디렉터리 내에 있는지 검증
        if (!file.getCanonicalPath().startsWith(new File(allowedDir).getCanonicalPath())) {
            response.setContentType("text/html; charset=UTF-8");
            out.println("잘못된 파일 요청입니다. 다운로드가 허용되지 않은 경로입니다.");
            return;
        }

        // 파일 존재 여부 확인
        if (file.exists() && file.isFile()) {
            // 응답 헤더 설정
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
