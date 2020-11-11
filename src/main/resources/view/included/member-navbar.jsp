<%-- 
    Document   : member-navbar
    Created on : Aug 15, 2019, 9:07:47 PM
    Author     : umairullah
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-md navbar-dark fixed-top bg-info">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/member/dashboard"><img src="${pageContext.request.contextPath}/resources/images/logo.png" class="w-75" alt="Trade Copier"></a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarCollapse">
        <ul class="navbar-nav mx-auto justify-content-md-center nav-c">
            <c:if test="${user.userType == 'ADMIN'}">
            <li class="nav-item dropdown <c:if test="${pageMenu eq 'Admin'}">active</c:if>">
                <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
                    Admin
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/manage-users">Users</a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/add-new-user">Add New User</a>
                </div>
            </li>
            </c:if>
        </ul>
        <ul class="navbar-nav ml-auto">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
                    Hi, <c:out value="${user.fname }"></c:out>
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a>
                </div>
            </li>
        </ul>
    </div>
</nav>