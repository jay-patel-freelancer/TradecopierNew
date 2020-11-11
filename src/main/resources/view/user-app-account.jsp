<%-- 
    Document   : user-app-account
    Created on : Aug 16, 2019, 12:42:23 AM
    Author     : umairullah
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="/WEB-INF/functions.tld" prefix="fa"%>
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
                            <h2>App Account(s) of 
                                <span style="text-transform: capitalize">${selectedUser.fname}</span>
                            |  ${selectedUser.userId}
                        </h2>
                    </div>
                    <table class="table table-condensed" style="margin-bottom:20px">
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
                                <span style="font-size:18px;">${selectedUser.userId }</span>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">Full Name</th>
                            <td style="text-transform: capitalize">
                                ${fn:toLowerCase(selectedUser.fname) }${fn:toLowerCase(selectedUser.lname) }
                            </td>
                            <th class="text-right">User since</th>
                            <td><fmt:formatDate value="${selectedUser.regDate }" pattern="MMM d, yyyy"/></td>
                        </tr>
                        <tr>
                            <th class="text-right">Email</th>
                            <td>${selectedUser.email }</td>
                            <th class="text-right">Phone</th>
                            <td>+91-${selectedUser.phoneNumber }</td>
                        </tr>
                        <tr>
                            <th class="text-right">Last Login Time</th>
                            <td><fmt:formatDate value="${selectedUser.lastLoginTime }" pattern="dd-MM-yyyy hh:mm a"/></td>
                            <th class="text-right">Last Login IP</th>
                            <td>${selectedUser.lastLoginIP }</td>
                        </tr>
                        <tr>
                            <th class="text-right">User Type</th>
                            <td>${selectedUser.userType }</td>
                            <th></th>
                            <td></td>
                        </tr>
                    </table>
                    <div class="headline">
                        <h3>Client Application Account(s)</h3>
                    </div>
                    <c:if test="${fn:length(accounts) eq 0 }">
                        <p class="text-danger"><strong>No client application account found :(</strong></p>
                    </c:if>
                    <c:set var="count" value="1"></c:set>
                    <c:forEach var="account" items="${accounts }">
                        <div class="headline">
                            <h4 style="text-transform: capitalize">${count}. ${fn:toLowerCase(fn:replace(account.clientAppName,"_"," ")) }</h4>
                            <c:set var="count" value="${count+1 }"></c:set>
                            </div>
                            <table class="table table-condensed table-bordered">  
                                <tr class="danger">
                                    <th colspan="4" class="text-center"><strong>Subscription Details</strong></th>
                                </tr>
                                <tr>
                                    <td class="text-right">Type</td>
                                    <td><strong>${account.subscriptionName }</strong></td>
                                <td class="text-right">Days Left</td>
                                <td><strong>
                                        <jsp:useBean id="now" class="java.util.Date" />
                                        <fmt:parseNumber
                                            value="${(account.subscriptionExpireDate.time - now.time) / (1000*60*60*24)+1 }"
                                            integerOnly="true" />
                                    </strong></td>
                            </tr>
                            <tr>
                                <td class="text-right">Start Date</td>
                                <td><strong><fmt:formatDate value="${account.subscriptionStartDate }" pattern="dd-MMM-yyyy"/></strong></td>
                                <td class="text-right">Expire Date</td>
                                <td><strong><fmt:formatDate value="${account.subscriptionExpireDate }" pattern="dd-MMM-yyyy"/></strong></td>
                            </tr>
                            <tr>
                                <td class="text-right">Subscribed For</td>
                                <td style="text-transform: capitalize;"><strong>${fn:toLowerCase(fn:replace(account.subscriptionFor,"_"," "))}</strong></td>  
                            <tr>
                                <td class="text-right">Change Subscription Type</td>
                                <td colspan="3" class="text-right">
                                    <form class="form-inline updateSubsForm">
                                        <div class="form-group">
                                            <select class="form-control form-control-sm" name="subFor" style="text-transform: capitalize;">
                                                <option value="-Subscription For-">-Subscription For-</option>
                                                <c:forEach var="subs" items="${fa:appSubscriptionArray(account.clientAppName) }">
                                                    <option value="${subs}">${fn:toLowerCase(fn:replace(subs,"_"," "))}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        &nbsp;|&nbsp;
                                        <div class="form-group">
                                            <select class="form-control form-control-sm subCbo">
                                                <option value="0">- Select -</option>
                                                <option value="6">6 days trail</option>
                                                <option value="30">1 Month</option>
                                                <option value="91">3 Months</option>
                                                <option value="183">6 Months</option>
                                                <option value="365">12 Months</option>
                                            </select>
                                        </div>
                                        OR
                                        <div class="form-group">
                                            <input name="subName" type="text" class="form-control form-control-sm" placeHolder="Subscription Name">
                                            <input name="subDays" type="text" class="form-control form-control-sm" placeHolder="Days">
                                            <input name="appName" type="hidden" value="${account.clientAppName }">
                                            <input name="rowId" type="hidden" value="${account.rowId }">
                                            <input name="action" type="hidden" value="updateSubscription">
                                        </div>&nbsp;
                                        <div class="form-group">
                                            <input name="appName" value="${account.clientAppName }" type="hidden">
                                            <button class="btn btn-primary btn-sm">Change</button>
                                        </div>
                                    </form>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" style="border-left-color: #fff;border-right-color: #fff;">&nbsp;</td>
                            </tr>
                            <tr class="danger">
                                <th colspan="4" class="text-center">
                                    <strong>Binded Device Details</strong>
                                    <button class="btn btn-danger btn-xs pull-right" onClick="releaseDevice(${account.rowId })">Release Device</button>
                                </th>
                            </tr>
                            <tr>
                                <td class="text-right">Device Id</td>
                                <td><strong>${account.bindedDeviceId }</strong></td>
                                <td class="text-right">Device Name</td>
                                <td><strong>${account.bindedDeviceName }</strong></td>
                            </tr>
                            <tr>
                                <td colspan="4" style="border-left-color: #fff;border-right-color: #fff;">&nbsp;</td>
                            </tr>  
                            <tr class="danger">
                                <th colspan="4" class="text-center"><strong>Login Details</strong></th>
                            </tr>  
                            <tr>
                                <td class="text-right">Last Login IP</td>
                                <td><strong>${account.lastLoginIP }</strong></td>
                                <td class="text-right">Last Login Time</td>
                                <td><strong><fmt:formatDate value="${account.lastLoginTime }" pattern="dd-MMM-yyyy hh:mm a"/></strong></td>
                            </tr>
                        </table>
                        <br>
                    </c:forEach>
                </div>
            </div>
        </div>
                    
                    <div class="modal fade in" id="responseBox" tabindex="-1" role="dialog" aria-hidden="false" style="display: none;">
    	<div class="modal-dialog modal-sm">
    		<div class="modal-content">
    			<div class="modal-header">
    				<h4 class="modal-title text-primary">App Account(s): </h4></div>
    			<div class="modal-body" style="padding: 10px 20px 0px;">
    				
    			</div>
    			<div class="modal-footer" style="padding: 10px 15px;">
    				<button type="button" class="btn btn-default btn-sm" data-dismiss="modal">Close</button>
    			</div>
    		</div>
    	</div>
    </div>

        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap4.min.js"></script>
        <script>
                                        $('.updateSubsForm').submit(function (e) {
                                            e.preventDefault();
                                            if (!confirm('Confirm to update subscription of the user?')) {
                                                return;
                                            }
                                            var error = false;
                                            var msg = '';
                                            $(this).find('input').each(function () {
                                                if (this.name == 'subName') {
                                                    if (this.value == null || this.value == '') {
                                                        error = true;
                                                        msg += "Subscription name is empty<br>";
                                                    }
                                                }
                                                if (this.name == 'subDays') {
                                                    if (this.value == null || this.value == '') {
                                                        error = true;
                                                        msg += "Subscription days is empty<br>";
                                                    } else if (!/^\d+$/.test(this.value)) {
                                                        error = true;
                                                        msg += "Subscription days should only contain digits";
                                                    }
                                                }
                                            });

                                            $(this).find('select').each(function () {
                                                if (this.name == 'subFor') {
                                                    if (this.value == '-Subscription For-' || this.value == '' || this.value == null) {
                                                        error = true;
                                                        msg += "Subscription for service is empty";
                                                    }
                                                }
                                            });

                                            if (error) {
                                                $('#responseBox').find('.modal-title').html('Something is incorrect');
                                                $('#responseBox').find('.modal-body').html('<p class="text-danger">' + msg + '</p>');
                                                $('#responseBox').find('.modal-footer').show();
                                                $('#responseBox').modal({
                                                    backdrop: 'static',
                                                    keyboard: false
                                                });
                                            } else {
                                                $('#responseBox').find('.modal-title').html(':P Doing...');
                                                $('#responseBox').find('.modal-body').html('<p class="text-muted text-center"><b class="glyphicon glyphicon-time"></b><br><strong>Updating Subscription.</strong> Please wait...</p>');
                                                $('#responseBox').find('.modal-footer').hide();
                                                $('#responseBox').modal({
                                                    backdrop: 'static',
                                                    keyboard: false
                                                });
                                                $.post('', $(this).serialize(), function (json) {
                                                    if (json.r_c == 0) {
                                                        $('#responseBox').find('.modal-title').text('Done :)');
                                                        $('#responseBox').find('.modal-body').html('<p class="text-primary"><b class="glyphicon glyphicon-ok"></b> ' + json.msg + '</p>');
                                                        $('#responseBox').find('.modal-footer').html(
                                                                '<button type="button" class="btn btn-success btn-sm" onClick="location.reload()">OK</button>'
                                                                );
                                                    } else {
                                                        $('#responseBox').find('.modal-title').text('Error');
                                                        $('#responseBox').find('.modal-body').html('<p class="text-danger"><b class="glyphicon glyphicon-warning-sign"></b><strong> Error: </strong> ' + json.msg + '</p>');
                                                    }
                                                })
                                                        .fail(function () {
                                                            $('#responseBox').find('.modal-title').text('Error');
                                                            $('#responseBox').find('.modal-body').html('<p class="text-danger">Unable to connect with Server. Please check your internet connectivity.</p>');
                                                        })
                                                        .always(function () {
                                                            $('#responseBox').find('.modal-footer').show();
                                                        });
                                            }
                                        });

                                        function releaseDevice(rowId) {
                                            if (!confirm('Release device from this user account?')) {
                                                return;
                                            }
                                            $('#responseBox').find('.modal-title').html(':P Doing...');
                                            $('#responseBox').find('.modal-body').html('<p class="text-muted text-center"><b class="glyphicon glyphicon-time"></b><br><strong>Releasing Device.</strong> Please wait...</p>');
                                            $('#responseBox').find('.modal-footer').hide();
                                            $('#responseBox').modal({
                                                backdrop: 'static',
                                                keyboard: false
                                            });
                                            $.post('', {action: 'releaseDevice', rowId: rowId}, function (json) {
                                                if (json.r_c == 0) {
                                                    $('#responseBox').find('.modal-title').text('Done :)');
                                                    $('#responseBox').find('.modal-body').html('<p class="text-primary"><b class="glyphicon glyphicon-ok"></b> ' + json.msg + '</p>');
                                                    $('#responseBox').find('.modal-footer').html(
                                                            '<button type="button" class="btn btn-success btn-sm" onClick="location.reload()">OK</button>'
                                                            );
                                                } else {
                                                    $('#responseBox').find('.modal-title').text('Error');
                                                    $('#responseBox').find('.modal-body').html('<p class="text-danger"><b class="glyphicon glyphicon-warning-sign"></b><strong> Error: </strong> ' + json.msg + '</p>');
                                                }
                                            })
                                                    .fail(function () {
                                                        $('#responseBox').find('.modal-title').text('Error');
                                                        $('#responseBox').find('.modal-body').html('<p class="text-danger">Unable to connect with Server. Please check your internet connectivity.</p>');
                                                    })
                                                    .always(function () {
                                                        $('#responseBox').find('.modal-footer').show();
                                                    });
                                        }
                                        $('.subCbo').change(function () {
                                            var days = parseInt($(this).val());
                                            if (days == 0) {
                                                days = '';
                                            }
                                            var subName = '';
                                            switch (days) {
                                                case 15:
                                                    subName = '15 days trail';
                                                    break;
                                                case 91:
                                                    subName = '3 months';
                                                    break;
                                                case 183:
                                                    subName = '6 months';
                                                    break;
                                                case 365:
                                                    subName = '12 months';
                                                    break;
                                            }
                                            var $form = $(this).parent().parent();
                                            $form.find('input').each(function () {
                                                if (this.name == 'subDays') {
                                                    this.value = days;
                                                }
                                                if (this.name == 'subName') {
                                                    this.value = subName;
                                                }
                                            });
                                        });
        </script>
    </body>
</html>
