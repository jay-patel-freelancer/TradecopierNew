<%-- 
    Document   : manage-users
    Created on : Aug 15, 2019, 10:04:48 PM
    Author     : umairullah
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trade Copier</title>
        <link href="${pageContext.request.contextPath}/resources/css/bootstrap4.min.css" rel="stylesheet" type="text/css"> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    </head>
    <body>
        <jsp:include page="included/member-navbar.jsp"></jsp:include>

            <div class="container">
                <div class="row">
                    <div class="col-md-10">
                        <div class="headline">
                            <h2>Manage Users</h2>
                        </div>
                        <div class="filter alert alert-info">
                            <div class="pull-left">
                                <h3 style="margin-top:0px;"><b class="fa fa-filter"></b> Search Filter&nbsp;&nbsp;&nbsp;</h3>
                            </div>
                            <div class="pull-left">
                                <form class="form-inline" role="form" id="textSearch">
                                    <div class="form-group">
                                        <label class="sr-only" for="filter">Name or Phone Number</label>
                                        <input type="text" class="form-control" id="filter" name="filter" placeholder="What to search" value="${param.filter}">
                                    <span class="input-error" id="filterErrorMsg" style="top: -10px;">Enter something to search</span>
                                </div>
                                <button type="submit" class="btn btn-default"><b class="fa fa-search"></b></button>
                                <a href="${pageContext.request.contextPath}/admin/manage-users" class="btn btn-danger"><b class="fa fa-remove"></b></a>
                            </form>
                        </div>
                        <div class="clearfix"></div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group text-center">
                            <label class="form-check-label">
                                <input type="checkbox" class="form-check-input" id="tcoo" <c:if test="${tcoo.onoff eq true}">checked</c:if> onclick="changeTCOO(${tcoo.id})">Trade Copier On/Off
                                </label>
                            </div>
                        </div>
                        <div class="row">
                        <c:forEach var="member" items="${members }">
                            <table class="table table-condensed" style="margin-bottom:20px" id="account-${member.userId }">
                                <colgroup>
                                    <col width="8%">
                                    <col width="15%">
                                    <col width="30%">
                                    <col width="15%">
                                    <col width="32%">
                                </colgroup>
                                <tr>
                                    <td rowspan="8" class="text-center">
                                        <span style="font-size:10px;">User ID</span><br/>
                                        <span style="font-size:18px;">${member.userId }</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="text-right">Full Name</th>
                                    <td style="text-transform: capitalize">
                                        ${fn:toLowerCase(member.fname) }
                                        ${fn:toLowerCase(member.lname) }
                                    </td>
                                    <th class="text-right">User since</th>
                                    <td><fmt:formatDate value="${member.regDate }" pattern="MMM d, yyyy"/></td>
                                </tr>
                                <tr>
                                    <th class="text-right">Email</th>
                                    <td>${member.email }</td>
                                    <th class="text-right">Phone</th>
                                    <td>+91-${member.phoneNumber }</td>
                                </tr>
                                <tr>
                                    <th class="text-right">Last Login Time</th>
                                    <td><fmt:formatDate value="${member.lastLoginTime }" pattern="dd-MM-yyyy hh:mm a"/></td>
                                    <th class="text-right">Last Login IP</th>
                                    <td>${member.lastLoginIP }</td>
                                </tr>
                                <tr>
                                    <th class="text-right">User Type</th>
                                    <td>${member.userType }</td>
                                    <th class="text-right">Master Limit</th>
                                    <td>
                                        <select class="form-control maslim" onchange="changeML(${member.userId }, this)">
                                            <c:forEach var="i" begin="0" end="100" step="1">
                                                <option <c:if test="${member.masterlimit eq i}">selected</c:if>>${i}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="text-right">Child Limit</th>
                                    <td>
                                        <select class="form-control chilim" onchange="changeCL(${member.userId }, this)">
                                            <c:forEach var="i" begin="0" end="100" step="1">
                                                <option <c:if test="${member.childlimit eq i}">selected</c:if>>${i}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <a class="btn btn-xs btn-info pull-right" style="margin-right:5px" href="${pageContext.request.contextPath}/admin/client-app-account?userId=${member.userId}">App Account(s)</a>
                                        <c:if test="${member.userType ne 'ADMIN'}">
                                            <button class="btn btn-xs btn-danger pull-right" style="margin-right:5px" onClick="deleteAccount(${member.userId })" id="delete-button-${member.userId }" data-loading-text="Deleting...">Delete</button>
                                        </c:if>
                                    </td>
                                </tr>
                            </table>
                        </c:forEach>

                    </div>	
                    <div class="row">
                        <div class="col-sm-6">
                            <form class="form-inline" role="form">
                                <div class="form-group">
                                    <label for="gotoPage">Goto Page: &nbsp;</label>
                                    <select class="form-control" id="gotoPage">
                                        <option>&nbsp;</option>
                                        <c:forEach var="i" begin="1" end="${totalPages }">
                                            <option><c:out value="${i }"></c:out> </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </form>
                        </div>
                        <div class="col-sm-6">
                            <ul class="pagination pull-right" style="margin:0">
                                <c:choose>
                                    <c:when test="${prevPage eq -1 }">
                                        <li class="disabled"><a href="#">&laquo;</a></li>
                                        </c:when>
                                        <c:otherwise>
                                        <li><a href="?page=${prevPage}">&laquo;</a></li>
                                        </c:otherwise>
                                    </c:choose>
                                <li class="active"><a href="#">Page ${currentPage} </a></li>
                                    <c:choose>
                                        <c:when test="${nextPage eq -1}">
                                        <li class="disabled"><a href="#">&raquo;</a></li>
                                        </c:when>
                                        <c:otherwise>
                                        <li><a href="?page=${nextPage}">&raquo;</a></li>
                                        </c:otherwise>
                                    </c:choose>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap4.min.js"></script>
        <script>
                                                $('#gotoPage').change(function () {
                                                    if ($(this).val() != '' || $(this).val() != null) {
                                                        location.href = '?page=' + $(this).val();
                                                    }
                                                });

                                                $('#textSearch').submit(function (e) {
                                                    $('#filter').parent().removeClass('has-error');
                                                    $('#filterErrorMsg').hide();
                                                    if ($('#filter').val() == '') {
                                                        $('#filter').parent().addClass('has-error');
                                                        $('#filterErrorMsg').show();
                                                        e.preventDefault();
                                                    }
                                                });

                                                function deleteAccount(accountId) {
                                                    if (!confirm('Confirm delete this Account?')) {
                                                        return;
                                                    }
                                                    var accountBoxId = "#account-" + accountId;
                                                    var buttonId = "#delete-button-" + accountId;
                                                    $(buttonId).button('loading');
                                                    $.post('', 'action=delete&userId=' + accountId, function (data) {
                                                        if (data.response == 'success') {
                                                            $(accountBoxId).slideUp();
                                                            setTimeout(function () {
                                                                $(accountBoxId).remove();
                                                            }, 2 * 1000);
                                                        } else {
                                                            alert(data.message);
                                                        }
                                                    });
                                                    $(buttonId).button('reset');
                                                }
                                                function changeML(accountId, newv) {
                                                    $.post('', 'action=changeML&userId=' + accountId + '&newv=' + newv.value, function (data) {

                                                    });
                                                }
                                                function changeCL(accountId, newv) {
                                                    $.post('', 'action=changeCL&userId=' + accountId + '&newv=' + newv.value, function (data) {

                                                    });
                                                }
                                                function changeMA(accountId, newv) {
                                                    $.post('', 'action=changeMA&userId=' + accountId + '&newv=' + newv.value, function (data) {

                                                    });
                                                }
                                                function changeMQ(accountId, newv) {
                                                    $.post('', 'action=changeMQ&userId=' + accountId + '&newv=' + newv.value, function (data) {

                                                    });
                                                }
                                                function changeTCOO(id) {
                                                    var action = 'add-tcoo';
                                                    var val = document.getElementById('tcoo').checked;
                                                    if (id == undefined || id == null) {
                                                        action = 'add-tcoo';
                                                    } else {
                                                        action = 'chnage-tcoo';
                                                    }
                                                    $.post('', 'action=' + action + '&id=' + id + '&newv=' + val, function (data) {
                                                        location.reload();
                                                    });
                                                }
        </script>
    </body>
</html>
