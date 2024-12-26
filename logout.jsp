<%@ include file="includes/header.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session != null) {
        session.invalidate(); // 세션 무효화
    }
    response.sendRedirect("login.jsp"); // 로그인 페이지로 리다이렉트
%>
