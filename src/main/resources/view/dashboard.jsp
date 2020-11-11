<%-- 
    Document   : dashboard
    Created on : Mar 4, 2020, 3:04:30 PM
    Author     : umair
--%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trade Copier</title>
        <link href="${pageContext.request.contextPath}/resources/css/bootstrap4.min.css" rel="stylesheet" type="text/css"> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/font-awesome.min.css" rel="stylesheet" type="text/css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap-toggle.min.css" rel="stylesheet" type="text/css">
        <style>
            .my-custom-scrollbar {
                position: relative;
                max-height: 400px;
                overflow: auto;
            }
            .table-wrapper-scroll-y {
                display: block;
            }
        </style>
    </head>
    <body>
        <jsp:include page="included/member-navbar.jsp"></jsp:include>
            <div class="container">
                <div class="row">
                    <div class="col-md-10">
                        <div class="headline">
                            <h2>Master Accounts</h2>
                        </div>
                        <div class="table-wrapper-scroll-y my-custom-scrollbar">
                            <input type="hidden" id="mlims" value="${mlims}"/>
                            <input type="hidden" id="clims" value="${clims}"/>

                            <table class="table table-bordered table-striped mb-0 mtable">
                                <thead>
                                    <tr>
                                        <th scope="col">Name</th>
                                        <th scope="col">Broker</th>
                                        <th scope="col">Login Id</th>
                                        <th scope="col">Password</th>
                                        <th scope="col">Status</th>
                                        <th scope="col">Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="macounts-table-body" class="tbl-body">
                                <c:forEach var="masterAccount" items="${masterAccounts}">
                                    <tr id="maccount-${masterAccount.id}" class="${masterAccount.id}">
                                        <td class="name">${masterAccount.name}</td>
                                        <td class="broker">${masterAccount.broker}</td>
                                        <td class="loginId">${masterAccount.loginId}</td>
                                        <td class="password">${masterAccount.password}</td>
                                        <td class="d-none pin">${masterAccount.pin}</td>
                                        <td class="d-none passcode">${masterAccount.passcode}</td>
                                        <td class="d-none q1">${masterAccount.q1}</td>
                                        <td class="d-none q2">${masterAccount.q2}</td>
                                        <td class="onoff">
                                            <input type="checkbox" <c:if test="${masterAccount.onOff == 'on'}">checked</c:if> data-toggle="toggle" data-onstyle="success" data-offstyle="danger" class="inonoff">
                                        </td>
                                        <td>
                                            <button class="btn btn-danger btn-sm" onclick="deleteMAccount(${masterAccount.id })">Delete</button>
                                            <button class="btn btn-primary btn-sm" onclick="modifyMAccount(${masterAccount.id })">Modify</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                    </div>
                    <br>
                    <div class="col-md-6 mx-auto">
                        <span class="btn-group">
                            <button class="btn btn-primary btn-sm" id="add-kite" data-toggle="modal" data-target="#kiteModal">Add Kite Account</button>
                            <button class="btn btn-primary btn-sm" id="add-upstox" data-toggle="modal" data-target="#upstoxModal">Add Upstox Account</button>
                            <button class="btn btn-primary btn-sm" id="add-ant" data-toggle="modal" data-target="#antModal">Add Ant Account</button>
                        </span>
                    </div>
                </div>
                <div class="col-md-10">
                    <div class="headline">
                        <h2>Child Accounts</h2>
                    </div>
                    <div class="table-wrapper-scroll-y my-custom-scrollbar">

                        <table class="table table-bordered table-striped mb-0 ctable">
                            <thead>
                                <tr>
                                    <th scope="col">Broker</th>
                                    <th scope="col">Login Id</th>
                                    <th scope="col">Password</th>
                                    <th scope="col">Master Account</th>
                                    <th scope="col">Multiplier</th>
                                    <th scope="col">Status</th>
                                    <th scope="col">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="cacounts-table-body" class="tbl-body">
                                <c:forEach var="childAccount" items="${childAccounts}">
                                    <tr id="caccount-${childAccount.id}" class="${childAccount.id} cm-${childAccount.masterId}">
                                        <td class="broker">${childAccount.broker}</td>
                                        <td class="loginId">${childAccount.loginId}</td>
                                        <td class="password">${childAccount.password}</td>
                                        <td class="man">${childAccount.masterName}</td>
                                        <td class="multi">${childAccount.qtyMultiply}</td>
                                        <td class="d-none pin">${childAccount.pin}</td>
                                        <td class="d-none passcode">${childAccount.passcode}</td>
                                        <td class="d-none q1">${childAccount.q1}</td>
                                        <td class="d-none q2">${childAccount.q2}</td>
                                        <td class="onoff">
                                            <input type="checkbox" <c:if test="${childAccount.onOff == 'on'}">checked</c:if> data-toggle="toggle" data-onstyle="success" data-offstyle="danger" class="inonoff">
                                        </td>
                                        <td>
                                            <button class="btn btn-danger btn-sm" onclick="deleteCAccount(${childAccount.id })">Delete</button>
                                            <button class="btn btn-primary btn-sm" onclick="modifyCAccount(${childAccount.id })">Modify</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                    </div>
                    <br>
                    <div class="col-md-6 mx-auto">
                        <span class="btn-group">
                            <button class="btn btn-primary btn-sm" id="add-kite" data-toggle="modal" data-target="#ckiteModal">Add Kite Account</button>
                            <button class="btn btn-primary btn-sm" id="add-upstox" data-toggle="modal" data-target="#cupstoxModal">Add Upstox Account</button>
                            <button class="btn btn-primary btn-sm" id="add-ant" data-toggle="modal" data-target="#cantModal">Add Ant Account</button>
                        </span>
                    </div>
                </div>
            </div>
        </div>


        <div class="modal" id="kiteModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Add Master Kite Account</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div class="col-md-12 text-center"><strong class="text-danger" id="mkite-msg"></strong></div>
                        <form id="mkite-form">
                            <div class="form-group">
                                <label for="mk-name">Unique Account Name:</label>
                                <input type="text" class="form-control" id="mk-name" name="mk-name">
                                <span class="input-error" id="mk-nameErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="mk-login-id">Login Id:</label>
                                <input type="text" class="form-control" id="mk-login-id" name="mk-login-id">
                                <span class="input-error" id="mk-loginIdErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="mpwd">Password:</label>
                                <input type="text" class="form-control" name="mk-password" id="mk-password">
                                <span class="input-error" id="mk-passwordErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="mpin">Pin:</label>
                                <input type="text" class="form-control" name="mk-pin" id="mk-pin">
                                <span class="input-error" id="mk-pinErrorMsg">Required field</span>
                            </div>
                            <input type="hidden" name="mk-id" id="mk-id" value=""/>
                            <button type="submit" class="btn btn-primary pull-right" id="mk-save">Save</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal" id="upstoxModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Add Master Upstox Account</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div class="col-md-12 text-center"><strong class="text-danger" id="mupstox-msg"></strong></div>
                        <form id="mupstox-form">
                            <div class="form-group">
                                <label for="mu-name">Unique Account Name:</label>
                                <input type="text" class="form-control" id="mu-name">
                                <span class="input-error" id="mu-nameErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="mu-login-id">Login Id:</label>
                                <input type="text" class="form-control" id="mu-login-id">
                                <span class="input-error" id="mu-loginIdErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="mu-password">Password:</label>
                                <input type="text" class="form-control" id="mu-password">
                                <span class="input-error" id="mu-passwordErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="mu-passcode">Passcode:</label>
                                <input type="text" class="form-control" id="mu-passcode">
                                <span class="input-error" id="mu-passcodeErrorMsg">Required field</span>
                            </div>
                            <input type="hidden" name="mu-id" id="mu-id" value=""/>
                            <button type="submit" class="btn btn-primary pull-right" id="mu-save">Save</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal" id="antModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Add Master Ant Account</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div class="col-md-12 text-center"><strong class="text-danger" id="mant-msg"></strong></div>
                        <form id="mant-form">
                            <div class="form-group">
                                <label for="ma-name">Unique Account Name:</label>
                                <input type="text" class="form-control" id="ma-name">
                                <span class="input-error" id="ma-nameErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="ma-login-id">Login Id:</label>
                                <input type="text" class="form-control" id="ma-login-id">
                                <span class="input-error" id="ma-loginIdErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="ma-password">Password:</label>
                                <input type="text" class="form-control" id="ma-password">
                                <span class="input-error" id="ma-passwordErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="ma-a1">Answer 1:</label>
                                <input type="text" class="form-control" id="ma-a1">
                                <span class="input-error" id="ma-a1ErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="ma-a2">Answer 2:</label>
                                <input type="text" class="form-control" id="ma-a2">
                                <span class="input-error" id="ma-a2ErrorMsg">Required field</span>
                            </div>
                            <input type="hidden" name="ma-id" id="ma-id" value=""/>
                            <button type="submit" class="btn btn-primary pull-right" id="ma-save">Save</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal" id="ckiteModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Add Child Kite Account</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div class="col-md-12 text-center"><strong class="text-danger" id="ckite-msg"></strong></div>
                        <form id="ckite-form">
                            <div class="form-group">
                                <label for="km-account">Master Account:</label>
                                <select class="form-control" id="km-account">
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="ck-login-id">Login Id:</label>
                                <input type="text" class="form-control" id="ck-login-id" name="ck-login-id">
                                <span class="input-error" id="ck-loginIdErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="cpwd">Password:</label>
                                <input type="text" class="form-control" name="ck-password" id="ck-password">
                                <span class="input-error" id="ck-passwordErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="cpin">Pin:</label>
                                <input type="text" class="form-control" name="ck-pin" id="ck-pin">
                                <span class="input-error" id="ck-pinErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="ckmulti">Multiplier:</label>
                                <input type="number" name="ckmulti" id="ckmulti" value="0.1" data-decimals="1" min="0.1" max="10000" step="0.1"/>
                                <span class="input-error" id="ck-multiErrorMsg">Required field</span>
                            </div>
                            <input type="hidden" name="ck-id" id="ck-id" value=""/>
                            <button type="submit" class="btn btn-primary pull-right" id="ck-save">Save</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal" id="cupstoxModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Add Child Upstox Account</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div class="col-md-12 text-center"><strong class="text-danger" id="cupstox-msg"></strong></div>
                        <form id="cupstox-form">
                            <div class="form-group">
                                <label for="um-account">Master Account:</label>
                                <select class="form-control" id="um-account">
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="cu-login-id">Login Id:</label>
                                <input type="text" class="form-control" id="cu-login-id">
                                <span class="input-error" id="cu-loginIdErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="cu-password">Password:</label>
                                <input type="text" class="form-control" id="cu-password">
                                <span class="input-error" id="cu-passwordErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="cu-passcode">Passcode:</label>
                                <input type="text" class="form-control" id="cu-passcode">
                                <span class="input-error" id="cu-passcodeErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="cumulti">Multiplier:</label>
                                <input type="number" name="cumulti" id="cumulti" value="0.1" data-decimals="1" min="0.1" max="10000" step="0.1"/>
                                <span class="input-error" id="cu-multiErrorMsg">Required field</span>
                            </div>
                            <input type="hidden" name="cu-id" id="cu-id" value=""/>
                            <button type="submit" class="btn btn-primary pull-right" id="cu-save">Save</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal" id="cantModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Add Child Ant Account</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div class="col-md-12 text-center"><strong class="text-danger" id="cant-msg"></strong></div>
                        <form id="cant-form">
                            <div class="form-group">
                                <label for="am-account">Master Account:</label>
                                <select class="form-control" id="am-account">
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="ca-login-id">Login Id:</label>
                                <input type="text" class="form-control" id="ca-login-id">
                                <span class="input-error" id="ca-loginIdErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="ca-password">Password:</label>
                                <input type="text" class="form-control" id="ca-password">
                                <span class="input-error" id="ca-passwordErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="ca-a1">Answer 1:</label>
                                <input type="text" class="form-control" id="ca-a1">
                                <span class="input-error" id="ca-a1ErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="ca-a2">Answer 2:</label>
                                <input type="text" class="form-control" id="ca-a2">
                                <span class="input-error" id="ca-a2ErrorMsg">Required field</span>
                            </div>
                            <div class="form-group">
                                <label for="camulti">Multiplier:</label>
                                <input type="number" name="camulti" id="camulti" value="0.1" data-decimals="1" min="0.1" max="10000" step="0.1"/>
                                <span class="input-error" id="ca-multiErrorMsg">Required field</span>
                            </div>
                            <input type="hidden" name="ca-id" id="ca-id" value=""/>
                            <button type="submit" class="btn btn-primary pull-right" id="ca-save">Save</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap4.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrapinputspinner.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap-toggle.min.js"></script>
        <script>
                                                $(function () {
                                                    $("input[type='number']").inputSpinner();
                                                    $('.inonoff').bootstrapToggle();
                                                    $('.inonoff').change(function() {
                                                        var onoff = 'on';
                                                        var action = 'modifychildonoff';
                                                        if($(this).prop('checked') == false){
                                                            onoff = 'off';
                                                        }
                                                        if($(this).closest('tr').attr('id').indexOf("maccount-") >= 0){
                                                            action = 'modifymasteronoff';
                                                        }
                                                        var Id = $(this).closest('tr').attr('class').split(' ')[0];
                                                      $.post('', {action: action, onoff: onoff, Id: Id}, function (json) {
                                                          
                                                      });
                                                    });
                                                    $('#mkite-form').on('submit', function (e) {
                                                        e.preventDefault();
                                                        $('.input-error').hide();
                                                        $('.has-error').removeClass('has-error');
                                                        $("#mkite-msg").text('');
                                                        var k_name = $("#mk-name").val().trim();
                                                        var k_login_id = $("#mk-login-id").val().trim();
                                                        var k_password = $("#mk-password").val().trim();
                                                        var k_pin = $("#mk-pin").val().trim();
                                                        var k_id = $("#mk-id").val();
                                                        var action = 'addmaster';
                                                        var error = false;
                                                        if (k_id != '' && k_id != null) {
                                                            action = 'modifymaster';
                                                        }

                                                        if (k_name == '' || k_name == null) {
                                                            $('#mk-name').parent().addClass('has-error');
                                                            $('#mk-nameErrorMsg').text('Required field');
                                                            $('#mk-nameErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (k_login_id == '' || k_login_id == null) {
                                                            $('#mk-login-id').parent().addClass('has-error');
                                                            $('#mk-loginIdErrorMsg').text('Required field');
                                                            $('#mk-loginIdErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (k_password == '' || k_password == null) {
                                                            $('#mk-password').parent().addClass('has-error');
                                                            $('#mk-passwordErrorMsg').text('Required field');
                                                            $('#mk-passwordErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (k_pin == '' || k_pin == null) {
                                                            $('#mk-pin').parent().addClass('has-error');
                                                            $('#mk-pinErrorMsg').text('Required field');
                                                            $('#mk-pinErrorMsg').show();
                                                            error = true;
                                                        }
                                                        
                                                        if(action == 'addmaster' && checkmlimt() == false){
                                                            error = true;
                                                            alert('You cannot add more master accounts. Limit exceeds!');
                                                        }

                                                        if (isExists("Kite", k_login_id, k_password, k_pin, null, null, null, k_id) == true) {
                                                            error = true;
                                                            alert('Account already exists in child or master Accounts!');
                                                        }

                                                        if (!error) {
                                                            $('#mk-save').prop('disabled', 'disabled');
                                                            $('#mk-save').val('Wait...');
                                                            $.post('', {action: action, loginId: k_login_id, password: k_password, pin: k_pin, Id: k_id, name: k_name, broker: 'Kite'}, function (json) {
                                                                if (json.response == 'success') {
                                                                    if (action == 'addmaster') {
                                                                        var html = '<tr id="maccount-' + json.Id + '" class="' + json.Id + '">';
                                                                        html += '<td class="name">' + k_name + '</td>';
                                                                        html += '<td class="broker">Kite</td>';
                                                                        html += '<td class="loginId">' + k_login_id + '</td>';
                                                                        html += '<td class="password">' + k_password + '</td>';
                                                                        html += '<td class="d-none pin">' + k_pin + '</td>';
                                                                        html += '<td class="d-none passcode"></td>';
                                                                        html += '<td class="d-none q1"></td>';
                                                                        html += '<td class="d-none q2"></td>';
                                                                        html += '<td class="onoff">';
                                                                        html += '<input type="checkbox" checked data-toggle="toggle" data-onstyle="success" data-offstyle="danger" class="inonoff">';
                                                                        html += '</td>';
                                                                        html += '<td>';
                                                                        html += '<button class="btn btn-danger btn-sm" onclick="deleteMAccount(' + json.Id + ')">Delete</button>';
                                                                        html += '<button class="btn btn-primary btn-sm" onclick="modifyMAccount(' + json.Id + ')">Modify</button>';
                                                                        html += '</td>';
                                                                        html += '</tr>';
                                                                        $('#macounts-table-body').append(html);
                                                                        $('.inonoff').bootstrapToggle();
                                                                    } else {
                                                                        $('#maccount-' + k_id).find('.name').text(k_name);
                                                                        $('#maccount-' + k_id).find('.broker').text('Kite');
                                                                        $('#maccount-' + k_id).find('.loginId').text(k_login_id);
                                                                        $('#maccount-' + k_id).find('.password').text(k_password);
                                                                        $('#maccount-' + k_id).find('.pin').text(k_pin);
                                                                        $('.cm-' + k_id).find('.man').text(k_name);
                                                                    }
                                                                    $("#mk-name").val('');
                                                                    $("#mk-login-id").val('');
                                                                    $("#mk-password").val('');
                                                                    $("#mk-pin").val('');
                                                                    $("#mk-id").val('');
                                                                    $('#mk-save').removeAttr('disabled');
                                                                    $('#mk-save').val('Save');
                                                                    $('#kiteModal').modal('hide');
                                                                } else {
                                                                    $('#mk-save').removeAttr('disabled');
                                                                    $("#mkite-msg").text('Error: ' + json.msg);
                                                                }
                                                            })
                                                                    .fail(function () {
                                                                        $('#mk-save').removeAttr('disabled');
                                                                        $("#mkite-msg").text('Error: Unable to connect with Server. Please check your internet connectivity.');
                                                                    });
                                                        }
                                                    });
                                                    $('#mupstox-form').on('submit', function (e) {
                                                        e.preventDefault();
                                                        $('.input-error').hide();
                                                        $('.has-error').removeClass('has-error');
                                                        $("#mupstox-msg").text('');
                                                        var u_name = $("#mu-name").val().trim();
                                                        var u_login_id = $("#mu-login-id").val().trim();
                                                        var u_password = $("#mu-password").val().trim();
                                                        var u_passcode = $("#mu-passcode").val().trim();
                                                        var u_id = $("#mu-id").val();
                                                        var action = 'addmaster';
                                                        var error = false;
                                                        if (u_id != '' && u_id != null) {
                                                            action = 'modifymaster';
                                                        }

                                                        if (u_name == '' || u_name == null) {
                                                            $('#mu-name').parent().addClass('has-error');
                                                            $('#mu-nameErrorMsg').text('Required field');
                                                            $('#mu-nameErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (u_login_id == '' || u_login_id == null) {
                                                            $('#mu-login-id').parent().addClass('has-error');
                                                            $('#mu-loginIdErrorMsg').text('Required field');
                                                            $('#mu-loginIdErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (u_password == '' || u_password == null) {
                                                            $('#mu-password').parent().addClass('has-error');
                                                            $('#mu-passwordErrorMsg').text('Required field');
                                                            $('#mu-passwordErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (u_passcode == '' || u_passcode == null) {
                                                            $('#mu-passcode').parent().addClass('has-error');
                                                            $('#mu-passcodeErrorMsg').text('Required field');
                                                            $('#mu-passcodeErrorMsg').show();
                                                            error = true;
                                                        }
                                                        
                                                        if(checkmlimt() == false){
                                                            error = true;
                                                            alert('You cannot add more master accounts. Limit exceeds!');
                                                        }

                                                        if (isExists("Upstox", u_login_id, u_password, null, u_passcode, null, null, u_id) == true) {
                                                            error = true;
                                                            alert('Account already exists in child or master Accounts!');
                                                        }

                                                        if (!error) {
                                                            $('#mu-save').prop('disabled', 'disabled');
                                                            $('#mu-save').val('Wait...');
                                                            $.post('', {action: action, loginId: u_login_id, password: u_password, passcode: u_passcode, Id: u_id, name: u_name, broker: 'Upstox'}, function (json) {
                                                                if (json.response == 'success') {
                                                                    if (action == 'addmaster') {
                                                                        var html = '<tr id="maccount-' + json.Id + '" class="' + json.Id + '">';
                                                                        html += '<td class="name">' + u_name + '</td>';
                                                                        html += '<td class="broker">Upstox</td>';
                                                                        html += '<td class="loginId">' + u_login_id + '</td>';
                                                                        html += '<td class="password">' + u_password + '</td>';
                                                                        html += '<td class="d-none pin"></td>';
                                                                        html += '<td class="d-none passcode">' + u_passcode + '</td>';
                                                                        html += '<td class="d-none q1"></td>';
                                                                        html += '<td class="d-none q2"></td>';
                                                                        html += '<td class="onoff">';
                                                                        html += '<input type="checkbox" checked data-toggle="toggle" data-onstyle="success" data-offstyle="danger" class="inonoff">';
                                                                        html += '</td>';
                                                                        html += '<td>';
                                                                        html += '<button class="btn btn-danger btn-sm" onclick="deleteMAccount(' + json.Id + ')">Delete</button>';
                                                                        html += '<button class="btn btn-primary btn-sm" onclick="modifyMAccount(' + json.Id + ')">Modify</button>';
                                                                        html += '</td>';
                                                                        html += '</tr>';
                                                                        $('#macounts-table-body').append(html);
                                                                        $('.inonoff').bootstrapToggle();
                                                                    } else {
                                                                        $('#maccount-' + u_id).find('.name').text(u_name);
                                                                        $('#maccount-' + u_id).find('.broker').text('Upstox');
                                                                        $('#maccount-' + u_id).find('.loginId').text(u_login_id);
                                                                        $('#maccount-' + u_id).find('.password').text(u_password);
                                                                        $('#maccount-' + u_id).find('.passcode').text(u_passcode);
                                                                        $('.cm-' + u_id).find('.man').text(u_name);
                                                                    }
                                                                    $("#mu-name").val('');
                                                                    $("#mu-login-id").val('');
                                                                    $("#mu-password").val('');
                                                                    $("#mu-passcode").val('');
                                                                    $("#mu-id").val('');
                                                                    $('#mu-save').removeAttr('disabled');
                                                                    $('#mu-save').val('Save');
                                                                    $('#upstoxModal').modal('hide');
                                                                } else {
                                                                    $('#mu-save').removeAttr('disabled');
                                                                    $("#mupstox-msg").text('Error: ' + json.msg);
                                                                }
                                                            })
                                                                    .fail(function () {
                                                                        $('#mu-save').removeAttr('disabled');
                                                                        $("#mupstox-msg").text('Error: Unable to connect with Server. Please check your internet connectivity.');
                                                                    });
                                                        }
                                                    });
                                                    $('#mant-form').on('submit', function (e) {
                                                        e.preventDefault();
                                                        $('.input-error').hide();
                                                        $('.has-error').removeClass('has-error');
                                                        $("#mant-msg").text('');
                                                        var a_name = $("#ma-name").val().trim();
                                                        var a_login_id = $("#ma-login-id").val().trim();
                                                        var a_password = $("#ma-password").val().trim();
                                                        var a_q1 = $("#ma-a1").val().trim();
                                                        var a_q2 = $("#ma-a2").val().trim();
                                                        var a_id = $("#ma-id").val();
                                                        var action = 'addmaster';
                                                        var error = false;
                                                        if (a_id != '' && a_id != null) {
                                                            action = 'modifymaster';
                                                        }

                                                        if (a_name == '' || a_name == null) {
                                                            $('#ma-name').parent().addClass('has-error');
                                                            $('#ma-nameErrorMsg').text('Required field');
                                                            $('#ma-nameErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (a_login_id == '' || a_login_id == null) {
                                                            $('#ma-login-id').parent().addClass('has-error');
                                                            $('#ma-loginIdErrorMsg').text('Required field');
                                                            $('#ma-loginIdErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (a_password == '' || a_password == null) {
                                                            $('#ma-password').parent().addClass('has-error');
                                                            $('#ma-passwordErrorMsg').text('Required field');
                                                            $('#ma-passwordErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (a_q1 == '' || a_q1 == null) {
                                                            $('#ma-a1').parent().addClass('has-error');
                                                            $('#ma-a1ErrorMsg').text('Required field');
                                                            $('#ma-a1ErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (a_q2 == '' || a_q2 == null) {
                                                            $('#ma-a2').parent().addClass('has-error');
                                                            $('#ma-a2ErrorMsg').text('Required field');
                                                            $('#ma-a2ErrorMsg').show();
                                                            error = true;
                                                        }
                                                        
                                                        if(checkmlimt() == false){
                                                            error = true;
                                                            alert('You cannot add more master accounts. Limit exceeds!');
                                                        }

                                                        if (isExists("Ant", a_login_id, a_password, null, null, a_q1, a_q2, a_id) == true) {
                                                            error = true;
                                                            alert('Account already exists in child or master Accounts!');
                                                        }

                                                        if (!error) {
                                                            $('#ma-save').prop('disabled', 'disabled');
                                                            $('#ma-save').val('Wait...');
                                                            $.post('', {action: action, loginId: a_login_id, password: a_password, q1: a_q1, q2: a_q2, Id: a_id, name: a_name, broker: 'Ant'}, function (json) {
                                                                if (json.response == 'success') {
                                                                    if (action == 'addmaster') {
                                                                        var html = '<tr id="maccount-' + json.Id + '" class="' + json.Id + '">';
                                                                        html += '<td class="name">' + a_name + '</td>';
                                                                        html += '<td class="broker">Ant</td>';
                                                                        html += '<td class="loginId">' + a_login_id + '</td>';
                                                                        html += '<td class="password">' + a_password + '</td>';
                                                                        html += '<td class="d-none pin"></td>';
                                                                        html += '<td class="d-none passcode"></td>';
                                                                        html += '<td class="d-none q1">' + a_q1 + '</td>';
                                                                        html += '<td class="d-none q2">' + a_q2 + '</td>';
                                                                        html += '<td class="onoff">';
                                                                        html += '<input type="checkbox" checked data-toggle="toggle" data-onstyle="success" data-offstyle="danger" class="inonoff">';
                                                                        html += '</td>';
                                                                        html += '<td>';
                                                                        html += '<button class="btn btn-danger btn-sm" onclick="deleteMAccount(' + json.Id + ')">Delete</button>';
                                                                        html += '<button class="btn btn-primary btn-sm" onclick="modifyMAccount(' + json.Id + ')">Modify</button>';
                                                                        html += '</td>';
                                                                        html += '</tr>';
                                                                        $('#macounts-table-body').append(html);
                                                                        $('.inonoff').bootstrapToggle();
                                                                    } else {
                                                                        $('#maccount-' + a_id).find('.name').text(a_name);
                                                                        $('#maccount-' + a_id).find('.broker').text('Ant');
                                                                        $('#maccount-' + a_id).find('.loginId').text(a_login_id);
                                                                        $('#maccount-' + a_id).find('.password').text(a_password);
                                                                        $('#maccount-' + a_id).find('.q1').text(a_q1);
                                                                        $('#maccount-' + a_id).find('.q2').text(a_q2);
                                                                        $('.cm-' + a_id).find('.man').text(a_name);
                                                                    }
                                                                    $("#ma-name").val('');
                                                                    $("#ma-login-id").val('');
                                                                    $("#ma-password").val('');
                                                                    $("#ma-a1").val('');
                                                                    $("#ma-a2").val('');
                                                                    $("#ma-id").val('');
                                                                    $('#ma-save').removeAttr('disabled');
                                                                    $('#ma-save').val('Save');
                                                                    $('#antModal').modal('hide');
                                                                } else {
                                                                    $('#ma-save').removeAttr('disabled');
                                                                    $("#mant-msg").text('Error: ' + json.msg);
                                                                }
                                                            })
                                                                    .fail(function () {
                                                                        $('#ma-save').removeAttr('disabled');
                                                                        $("#mant-msg").text('Error: Unable to connect with Server. Please check your internet connectivity.');
                                                                    });
                                                        }
                                                    });
                                                    $('#ckite-form').on('submit', function (e) {
                                                        e.preventDefault();
                                                        $('.input-error').hide();
                                                        $('.has-error').removeClass('has-error');
                                                        $("#ckite-msg").text('');
                                                        var k_m_Id = $("#km-account").find(":selected").val();
                                                        var k_m_name = $("#km-account").find(":selected").text();
                                                        var k_login_id = $("#ck-login-id").val().trim();
                                                        var k_password = $("#ck-password").val().trim();
                                                        var k_pin = $("#ck-pin").val().trim();
                                                        var k_id = $("#ck-id").val();
                                                        var qtyMul = $("#ckmulti").val();
                                                        var action = 'addchild';
                                                        var error = false;
                                                        if (k_id != '' && k_id != null) {
                                                            action = 'modifychild';
                                                        }

                                                        if (k_login_id == '' || k_login_id == null) {
                                                            $('#ck-login-id').parent().addClass('has-error');
                                                            $('#ck-loginIdErrorMsg').text('Required field');
                                                            $('#ck-loginIdErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (k_password == '' || k_password == null) {
                                                            $('#ck-password').parent().addClass('has-error');
                                                            $('#ck-passwordErrorMsg').text('Required field');
                                                            $('#ck-passwordErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (k_pin == '' || k_pin == null) {
                                                            $('#ck-pin').parent().addClass('has-error');
                                                            $('#ck-pinErrorMsg').text('Required field');
                                                            $('#ck-pinErrorMsg').show();
                                                            error = true;
                                                        }
                                                        
                                                        if(checkclimt(k_m_name) == false){
                                                            error = true;
                                                            alert('You cannot add more child accounts for selected master account. Limit Exceeds!');
                                                        }

                                                        if (isExists("Kite", k_login_id, k_password, k_pin, null, null, null, k_id) == true) {
                                                            error = true;
                                                            alert('Account already exists in child or master Accounts!');
                                                        }

                                                        if (!error) {
                                                            $('#ck-save').prop('disabled', 'disabled');
                                                            $('#ck-save').val('Wait...');
                                                            $.post('', {action: action, loginId: k_login_id, password: k_password, pin: k_pin, Id: k_id, masterId: k_m_Id, broker: 'Kite', qtyMul: qtyMul}, function (json) {
                                                                if (json.response == 'success') {
                                                                    if (action == 'addchild') {
                                                                        var html = '<tr id="caccount-' + json.Id + '" class="' + json.Id + ' cm-' + k_m_Id + '">';
                                                                        html += '<td class="broker">Kite</td>';
                                                                        html += '<td class="loginId">' + k_login_id + '</td>';
                                                                        html += '<td class="password">' + k_password + '</td>';
                                                                        html += '<td class="man">' + k_m_name + '</td>';
                                                                        html += '<td class="multi">' + qtyMul + '</td>';
                                                                        html += '<td class="d-none pin">' + k_pin + '</td>';
                                                                        html += '<td class="d-none passcode"></td>';
                                                                        html += '<td class="d-none q1"></td>';
                                                                        html += '<td class="d-none q2"></td>';
                                                                        html += '<td class="onoff">';
                                                                        html += '<input type="checkbox" checked data-toggle="toggle" data-onstyle="success" data-offstyle="danger" class="inonoff">';
                                                                        html += '</td>';
                                                                        html += '<td>';
                                                                        html += '<button class="btn btn-danger btn-sm" onclick="deleteCAccount(' + json.Id + ')">Delete</button>';
                                                                        html += '<button class="btn btn-primary btn-sm" onclick="modifyCAccount(' + json.Id + ')">Modify</button>';
                                                                        html += '</td>';
                                                                        html += '</tr>';
                                                                        $('#cacounts-table-body').append(html);
                                                                        $('.inonoff').bootstrapToggle();
                                                                    } else {
                                                                        $('#caccount-' + k_id).find('.broker').text('Kite');
                                                                        $('#caccount-' + k_id).find('.loginId').text(k_login_id);
                                                                        $('#caccount-' + k_id).find('.password').text(k_password);
                                                                        $('#caccount-' + k_id).find('.pin').text(k_pin);
                                                                        $('#caccount-' + k_id).find('.man').text(k_m_name);
                                                                        $('#caccount-' + k_id).find('.multi').text(qtyMul);
                                                                        $('#caccount-' + k_id).removeClass($('#caccount-' + k_id).attr("class").split(' ')[1]);
                                                                        $('#caccount-' + k_id).addClass('cm-' + k_m_Id);
                                                                    }
                                                                    $('#km-account').html('');
                                                                    $("#ck-login-id").val('');
                                                                    $("#ck-password").val('');
                                                                    $("#ck-pin").val('');
                                                                    $("#ckmulti").val('0.1');
                                                                    $("#ck-id").val('');
                                                                    $('#ck-save').removeAttr('disabled');
                                                                    $('#ck-save').val('Save');
                                                                    $('#ckiteModal').modal('hide');
                                                                } else {
                                                                    $('#ck-save').removeAttr('disabled');
                                                                    $("#ckite-msg").text('Error: ' + json.msg);
                                                                }
                                                            })
                                                                    .fail(function () {
                                                                        $('#ck-save').removeAttr('disabled');
                                                                        $("#ckite-msg").text('Error: Unable to connect with Server. Please check your internet connectivity.');
                                                                    });
                                                        }
                                                    });
                                                    $('#cupstox-form').on('submit', function (e) {
                                                        e.preventDefault();
                                                        $('.input-error').hide();
                                                        $('.has-error').removeClass('has-error');
                                                        $("#cupstox-msg").text('');
                                                        var u_m_Id = $("#um-account").find(":selected").val();
                                                        var u_m_name = $("#um-account").find(":selected").text();
                                                        var u_login_id = $("#cu-login-id").val().trim();
                                                        var u_password = $("#cu-password").val().trim();
                                                        var u_passcode = $("#cu-passcode").val().trim();
                                                        var qtyMul = $("#cumulti").val();
                                                        var u_id = $("#cu-id").val();
                                                        var action = 'addchild';
                                                        var error = false;
                                                        if (u_id != '' && u_id != null) {
                                                            action = 'modifychild';
                                                        }

                                                        if (u_login_id == '' || u_login_id == null) {
                                                            $('#cu-login-id').parent().addClass('has-error');
                                                            $('#cu-loginIdErrorMsg').text('Required field');
                                                            $('#cu-loginIdErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (u_password == '' || u_password == null) {
                                                            $('#cu-password').parent().addClass('has-error');
                                                            $('#cu-passwordErrorMsg').text('Required field');
                                                            $('#cu-passwordErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (u_passcode == '' || u_passcode == null) {
                                                            $('#cu-passcode').parent().addClass('has-error');
                                                            $('#cu-passcodeErrorMsg').text('Required field');
                                                            $('#cu-passcodeErrorMsg').show();
                                                            error = true;
                                                        }
                                                        
                                                        if(checkclimt(u_m_name) == false){
                                                            error = true;
                                                            alert('You cannot add more child accounts for selected master account. Limit Exceeds!');
                                                        }

                                                        if (isExists("Upstox", u_login_id, u_password, null, u_passcode, null, null, u_id) == true) {
                                                            error = true;
                                                            alert('Account already exists in child or master Accounts!');
                                                        }

                                                        if (!error) {
                                                            $('#cu-save').prop('disabled', 'disabled');
                                                            $('#cu-save').val('Wait...');
                                                            $.post('', {action: action, loginId: u_login_id, password: u_password, passcode: u_passcode, Id: u_id, masterId: u_m_Id, broker: 'Upstox', qtyMul: qtyMul}, function (json) {
                                                                if (json.response == 'success') {
                                                                    if (action == 'addchild') {
                                                                        var html = '<tr id="caccount-' + json.Id + '" class="' + json.Id + ' cm-' + u_m_Id + '">';
                                                                        html += '<td class="broker">Upstox</td>';
                                                                        html += '<td class="loginId">' + u_login_id + '</td>';
                                                                        html += '<td class="password">' + u_password + '</td>';
                                                                        html += '<td class="man">' + u_m_name + '</td>';
                                                                        html += '<td class="multi">' + qtyMul + '</td>';
                                                                        html += '<td class="d-none pin"></td>';
                                                                        html += '<td class="d-none passcode">' + u_passcode + '</td>';
                                                                        html += '<td class="d-none q1"></td>';
                                                                        html += '<td class="d-none q2"></td>';
                                                                        html += '<td class="onoff">';
                                                                        html += '<input type="checkbox" checked data-toggle="toggle" data-onstyle="success" data-offstyle="danger" class="inonoff">';
                                                                        html += '</td>';
                                                                        html += '<td>';
                                                                        html += '<button class="btn btn-danger btn-sm" onclick="deleteCAccount(' + json.Id + ')">Delete</button>';
                                                                        html += '<button class="btn btn-primary btn-sm" onclick="modifyCAccount(' + json.Id + ')">Modify</button>';
                                                                        html += '</td>';
                                                                        html += '</tr>';
                                                                        $('#cacounts-table-body').append(html);
                                                                        $('.inonoff').bootstrapToggle();
                                                                    } else {
                                                                        $('#caccount-' + u_id).find('.broker').text('Upstox');
                                                                        $('#caccount-' + u_id).find('.loginId').text(u_login_id);
                                                                        $('#caccount-' + u_id).find('.password').text(u_password);
                                                                        $('#caccount-' + u_id).find('.pin').text(u_passcode);
                                                                        $('#caccount-' + u_id).find('.man').text(u_m_name);
                                                                        $('#caccount-' + u_id).find('.multi').text(qtyMul);
                                                                        $('#caccount-' + u_id).removeClass($('#caccount-' + u_id).attr("class").split(' ')[1]);
                                                                        $('#caccount-' + u_id).addClass('cm-' + u_m_Id);
                                                                    }
                                                                    $('#um-account').html('');
                                                                    $("#cu-login-id").val('');
                                                                    $("#cu-password").val('');
                                                                    $("#cu-passcode").val('');
                                                                    $("#qtyMul").val('0.1');
                                                                    $("#cu-id").val('');
                                                                    $('#cu-save').removeAttr('disabled');
                                                                    $('#cu-save').val('Save');
                                                                    $('#cupstoxModal').modal('hide');
                                                                } else {
                                                                    $('#cu-save').removeAttr('disabled');
                                                                    $("#cupstox-msg").text('Error: ' + json.msg);
                                                                }
                                                            })
                                                                    .fail(function () {
                                                                        $('#cu-save').removeAttr('disabled');
                                                                        $("#cupstox-msg").text('Error: Unable to connect with Server. Please check your internet connectivity.');
                                                                    });
                                                        }
                                                    });
                                                    $('#cant-form').on('submit', function (e) {
                                                        e.preventDefault();
                                                        $('.input-error').hide();
                                                        $('.has-error').removeClass('has-error');
                                                        $("#cant-msg").text('');
                                                        var a_m_Id = $("#am-account").find(":selected").val();
                                                        var a_m_name = $("#am-account").find(":selected").text();
                                                        var a_login_id = $("#ca-login-id").val().trim();
                                                        var a_password = $("#ca-password").val().trim();
                                                        var a_q1 = $("#ca-a1").val().trim();
                                                        var a_q2 = $("#ca-a2").val().trim();
                                                        var a_id = $("#ca-id").val();
                                                        var qtyMul = $("#camulti").val();
                                                        var action = 'addchild';
                                                        var error = false;
                                                        if (a_id != '' && a_id != null) {
                                                            action = 'modifychild';
                                                        }

                                                        if (a_login_id == '' || a_login_id == null) {
                                                            $('#ca-login-id').parent().addClass('has-error');
                                                            $('#ca-loginIdErrorMsg').text('Required field');
                                                            $('#ca-loginIdErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (a_password == '' || a_password == null) {
                                                            $('#ca-password').parent().addClass('has-error');
                                                            $('#ca-passwordErrorMsg').text('Required field');
                                                            $('#ca-passwordErrorMsg').show();
                                                            error = true;
                                                        }
                                                        if (a_q1 == '' || a_q1 == null) {
                                                            $('#ca-a1').parent().addClass('has-error');
                                                            $('#ca-a1ErrorMs').text('Required field');
                                                            $('#ca-a1ErrorMs').show();
                                                            error = true;
                                                        }
                                                        if (a_q2 == '' || a_q2 == null) {
                                                            $('#ca-a2').parent().addClass('has-error');
                                                            $('#ca-a2ErrorMs').text('Required field');
                                                            $('#ca-a2ErrorMs').show();
                                                            error = true;
                                                        }
                                                        
                                                        if(checkclimt(a_m_name) == false){
                                                            error = true;
                                                            alert('You cannot add more child accounts for selected master account. Limit Exceeds!');
                                                        }

                                                        if (isExists("Ant", a_login_id, a_password, null, null, a_q1, a_q2, a_id) == true) {
                                                            error = true;
                                                            alert('Account already exists in child or master Accounts!');
                                                        }

                                                        if (!error) {
                                                            $('#ca-save').prop('disabled', 'disabled');
                                                            $('#ca-save').val('Wait...');
                                                            $.post('', {action: action, loginId: a_login_id, password: a_password, q1: a_q1, q2: a_q2, Id: a_id, masterId: a_m_Id, broker: 'Ant', qtyMul: qtyMul}, function (json) {
                                                                if (json.response == 'success') {
                                                                    if (action == 'addchild') {
                                                                        var html = '<tr id="caccount-' + json.Id + '" class="' + json.Id + ' cm-' + a_m_Id + '">';
                                                                        html += '<td class="broker">Ant</td>';
                                                                        html += '<td class="loginId">' + a_login_id + '</td>';
                                                                        html += '<td class="password">' + a_password + '</td>';
                                                                        html += '<td class="man">' + a_m_name + '</td>';
                                                                        html += '<td class="multi">' + qtyMul + '</td>';
                                                                        html += '<td class="d-none pin"></td>';
                                                                        html += '<td class="d-none passcode"></td>';
                                                                        html += '<td class="d-none q1">' + a_q1 + '</td>';
                                                                        html += '<td class="d-none q2">' + a_q2 + '</td>';
                                                                        html += '<td class="onoff">';
                                                                        html += '<input type="checkbox" checked data-toggle="toggle" data-onstyle="success" data-offstyle="danger" class="inonoff">';
                                                                        html += '</td>';
                                                                        html += '<td>';
                                                                        html += '<button class="btn btn-danger btn-sm" onclick="deleteCAccount(' + json.Id + ')">Delete</button>';
                                                                        html += '<button class="btn btn-primary btn-sm" onclick="modifyCAccount(' + json.Id + ')">Modify</button>';
                                                                        html += '</td>';
                                                                        html += '</tr>';
                                                                        $('#cacounts-table-body').append(html);
                                                                        $('.inonoff').bootstrapToggle();
                                                                    } else {
                                                                        $('#caccount-' + a_id).find('.broker').text('Ant');
                                                                        $('#caccount-' + a_id).find('.loginId').text(a_login_id);
                                                                        $('#caccount-' + a_id).find('.password').text(a_password);
                                                                        $('#caccount-' + a_id).find('.q1').text(a_q1);
                                                                        $('#caccount-' + a_id).find('.q2').text(a_q2);
                                                                        $('#caccount-' + a_id).find('.man').text(a_m_name);
                                                                        $('#caccount-' + a_id).find('.multi').text(qtyMul);
                                                                        $('#caccount-' + a_id).removeClass($('#caccount-' + a_id).attr("class").split(' ')[1]);
                                                                        $('#caccount-' + a_id).addClass('cm-' + a_m_Id);
                                                                    }
                                                                    $('#am-account').html('');
                                                                    $("#ca-login-id").val('');
                                                                    $("#ca-password").val('');
                                                                    $("#ca-a1").val('');
                                                                    $("#ca-a2").val('');
                                                                    $("#ca-id").val('');
                                                                    $("#camulti").val('0.1');
                                                                    $('#ca-save').removeAttr('disabled');
                                                                    $('#ca-save').val('Save');
                                                                    $('#cantModal').modal('hide');
                                                                } else {
                                                                    $('#ca-save').removeAttr('disabled');
                                                                    $("#cant-msg").text('Error: ' + json.msg);
                                                                }
                                                            })
                                                                    .fail(function () {
                                                                        $('#ca-save').removeAttr('disabled');
                                                                        $("#cant-msg").text('Error: Unable to connect with Server. Please check your internet connectivity.');
                                                                    });
                                                        }
                                                    });
                                                    $("#antModal").on("hidden.bs.modal", function () {
                                                        $("#ma-name").val('');
                                                        $("#ma-login-id").val('');
                                                        $("#ma-password").val('');
                                                        $("#ma-a1").val('');
                                                        $("#ma-a2").val('');
                                                        $("#ma-id").val('');
                                                        $('#ma-save').removeAttr('disabled');
                                                        $('#ma-save').val('Save');
                                                    });
                                                    $("#upstoxModal").on("hidden.bs.modal", function () {
                                                        $("#mu-name").val('');
                                                        $("#mu-login-id").val('');
                                                        $("#mu-password").val('');
                                                        $("#mu-passcode").val('');
                                                        $("#mu-id").val('');
                                                        $('#mu-save').removeAttr('disabled');
                                                        $('#mu-save').val('Save');
                                                    });
                                                    $("#kiteModal").on("hidden.bs.modal", function () {
                                                        $("#mk-name").val('');
                                                        $("#mk-login-id").val('');
                                                        $("#mk-password").val('');
                                                        $("#mk-pin").val('');
                                                        $("#mk-id").val('');
                                                        $('#mk-save').removeAttr('disabled');
                                                        $('#mk-save').val('Save');
                                                    });
                                                    $("#ckiteModal").on("hidden.bs.modal", function () {
                                                        $('#km-account').html('');
                                                        $("#ck-login-id").val('');
                                                        $("#ck-password").val('');
                                                        $("#ck-pin").val('');
                                                        $("#ckmulti").val('0.1');
                                                        $("#ck-id").val('');
                                                        $('#ck-save').removeAttr('disabled');
                                                        $('#ck-save').val('Save');
                                                    });
                                                    $("#cupstoxModal").on("hidden.bs.modal", function () {
                                                        $('#um-account').html('');
                                                        $("#cu-login-id").val('');
                                                        $("#cu-password").val('');
                                                        $("#cu-passcode").val('');
                                                        $("#cumulti").val('0.1');
                                                        $("#cu-id").val('');
                                                        $('#cu-save').removeAttr('disabled');
                                                        $('#cu-save').val('Save');
                                                    });
                                                    $("#cantModal").on("hidden.bs.modal", function () {
                                                        $('#am-account').html('');
                                                        $("#ca-login-id").val('');
                                                        $("#ca-password").val('');
                                                        $("#ca-a1").val('');
                                                        $("#ca-a2").val('');
                                                        $("#camulti").val('0.1');
                                                        $("#ca-id").val('');
                                                        $('#ca-save').removeAttr('disabled');
                                                        $('#ca-save').val('Save');
                                                    });
                                                    $('#ckiteModal').on('shown.bs.modal', function () {
                                                        if ($('#km-account option').length == 0) {
                                                            var html = '';
                                                            $('#macounts-table-body > tr').each(function (i, obj) {
                                                                var mId = $(obj).attr("class");
                                                                var name = $(obj).find('.name').text();
                                                                html += '<option value="' + mId + '">' + name + '</option>';
                                                            });
                                                            $('#km-account').html(html);
                                                        }
                                                    });
                                                    $('#cupstoxModal').on('shown.bs.modal', function () {
                                                        if ($('#um-account option').length == 0) {
                                                            var html = '';
                                                            $('#macounts-table-body > tr').each(function (i, obj) {
                                                                var mId = $(obj).attr("class");
                                                                var name = $(obj).find('.name').text();
                                                                html += '<option value="' + mId + '">' + name + '</option>';
                                                            });
                                                            $('#um-account').html(html);
                                                        }
                                                    });
                                                    $('#cantModal').on('shown.bs.modal', function () {
                                                        if ($('#am-account option').length == 0) {
                                                            var html = '';
                                                            $('#macounts-table-body > tr').each(function (i, obj) {
                                                                var mId = $(obj).attr("class");
                                                                var name = $(obj).find('.name').text();
                                                                html += '<option value="' + mId + '">' + name + '</option>';
                                                            });
                                                            $('#am-account').html(html);
                                                        }
                                                    });
                                                });
                                                function modifyMAccount(id) {
                                                    var name = $('#maccount-' + id).find('.name').text();
                                                    var broker = $('#maccount-' + id).find('.broker').text();
                                                    var loginId = $('#maccount-' + id).find('.loginId').text();
                                                    var password = $('#maccount-' + id).find('.password').text();
                                                    if (broker.trim() == 'Kite') {
                                                        $("#mk-name").val(name);
                                                        $("#mk-login-id").val(loginId);
                                                        $("#mk-password").val(password);
                                                        $("#mk-pin").val($('#maccount-' + id).find('.pin').text());
                                                        $("#mk-id").val(id);
                                                        $('#kiteModal').modal('show');
                                                    } else if (broker.trim() == 'Upstox') {
                                                        $("#mu-name").val(name);
                                                        $("#mu-login-id").val(loginId);
                                                        $("#mu-password").val(password);
                                                        $("#mu-passcode").val($('#maccount-' + id).find('.passcode').text());
                                                        $("#mu-id").val(id);
                                                        $('#upstoxModal').modal('show');
                                                    } else if (broker.trim() == 'Ant') {
                                                        $("#ma-name").val(name);
                                                        $("#ma-login-id").val(loginId);
                                                        $("#ma-password").val(password);
                                                        $("#ma-a1").val($('#maccount-' + id).find('.q1').text());
                                                        $("#ma-a2").val($('#maccount-' + id).find('.q2').text());
                                                        $("#ma-id").val(id);
                                                        $('#antModal').modal('show');
                                                    }
                                                }

                                                function modifyCAccount(id) {
                                                    var broker = $('#caccount-' + id).find('.broker').text();
                                                    var loginId = $('#caccount-' + id).find('.loginId').text();
                                                    var password = $('#caccount-' + id).find('.password').text();
                                                    var man = $('#caccount-' + id).find('.man').text();
                                                    if (broker.trim() == 'Kite') {
                                                        $("#ck-login-id").val(loginId);
                                                        $("#ck-password").val(password);
                                                        $("#ck-pin").val($('#caccount-' + id).find('.pin').text());
                                                        $("#ckmulti").val($('#caccount-' + id).find('.multi').text());
                                                        $("#ck-id").val(id);
                                                        var html = '';
                                                        $('#macounts-table-body > tr').each(function (i, obj) {
                                                            var mId = $(obj).attr("class");
                                                            var name = $(obj).find('.name').text();
                                                            if (name.trim() == man.trim()) {
                                                                html += '<option value="' + mId + '" selected="selected">' + name + '</option>';
                                                            } else {
                                                                html += '<option value="' + mId + '">' + name + '</option>';
                                                            }
                                                        });
                                                        $('#km-account').html(html);
                                                        $('#ckiteModal').modal('show');
                                                    } else if (broker.trim() == 'Upstox') {
                                                        $("#cu-login-id").val(loginId);
                                                        $("#cu-password").val(password);
                                                        $("#cu-passcode").val($('#caccount-' + id).find('.passcode').text());
                                                        $("#cumulti").val($('#caccount-' + id).find('.multi').text());
                                                        $("#cu-id").val(id);
                                                        var html = '';
                                                        $('#macounts-table-body > tr').each(function (i, obj) {
                                                            var mId = $(obj).attr("class");
                                                            var name = $(obj).find('.name').text();
                                                            if (name.trim() == man.trim()) {
                                                                html += '<option value="' + mId + '" selected="selected">' + name + '</option>';
                                                            } else {
                                                                html += '<option value="' + mId + '">' + name + '</option>';
                                                            }
                                                        });
                                                        $('#um-account').html(html);
                                                        $('#cupstoxModal').modal('show');
                                                    } else if (broker.trim() == 'Ant') {
                                                        $("#ca-login-id").val(loginId);
                                                        $("#ca-password").val(password);
                                                        $("#ca-a1").val($('#caccount-' + id).find('.q1').text());
                                                        $("#ca-a2").val($('#caccount-' + id).find('.q2').text());
                                                        $("#camulti").val($('#caccount-' + id).find('.multi').text());
                                                        $("#ca-id").val(id);
                                                        var html = '';
                                                        $('#macounts-table-body > tr').each(function (i, obj) {
                                                            var mId = $(obj).attr("class");
                                                            var name = $(obj).find('.name').text();
                                                            if (name.trim() == man.trim()) {
                                                                html += '<option value="' + mId + '" selected="selected">' + name + '</option>';
                                                            } else {
                                                                html += '<option value="' + mId + '">' + name + '</option>';
                                                            }
                                                        });
                                                        $('#am-account').html(html);
                                                        $('#cantModal').modal('show');
                                                    }
                                                }

                                                function deleteMAccount(id) {
                                                    $.post('', {action: 'deletemaster', Id: id}, function (json) {
                                                        if (json.response == 'success') {
                                                            $('#macounts-table-body').find("#maccount-" + id).remove();
                                                            $('#cacounts-table-body').find(".cm-" + id).remove();
                                                        } else {
                                                            alert('Error: ' + json.msg);
                                                        }
                                                    })
                                                            .fail(function () {
                                                                alert('Unable to connect with Server. Please check your internet connectivity.');
                                                            })
                                                }

                                                function deleteCAccount(id) {
                                                    $.post('', {action: 'deletechild', Id: id}, function (json) {
                                                        if (json.response == 'success') {
                                                            $('#cacounts-table-body').find("#caccount-" + id).remove();
                                                        } else {
                                                            alert('Error: ' + json.msg);
                                                        }
                                                    })
                                                            .fail(function () {
                                                                alert('Unable to connect with Server. Please check your internet connectivity.');
                                                            })
                                                }
                                                
                                                function checkmlimt(){
                                                    var retVal = true;
                                                    if($('.mtable .tbl-body tr').length >= $('#mlims').val()){
                                                        retVal = false;
                                                    }
                                                    return retVal;
                                                }
                                                
                                                function checkclimt(name){
                                                    var retVal = true;
                                                    var count = 0;
                                                    $('.ctable .tbl-body tr').each(function (i, row) {
                                                        if($(row).find('.man').text().trim() == name.trim()){
                                                            count++;
                                                        }
                                                    });
                                                    if(count >= $('#clims').val()){
                                                        retVal = false;
                                                    }
                                                    return retVal;
                                                }

                                                function isExists(broker, loginId, pwd, pin, passcode, q1, q2, id) {
                                                    var retVal = false;
                                                    $('.tbl-body tr').each(function (i, row) {
                                                        if (broker == 'Kite' && $(row).find('.broker').text() == broker
                                                                && $(row).find('.loginId').text() == loginId && $(row).find('.password').text() == pwd
                                                                && $(row).find('.pin').text() == pin) {
                                                            if (id != null && id != '' && $(row).attr('class').split(' ')[0] == id) {
                                                                retVal = false;
                                                            } else {
                                                                retVal = true;
                                                            }
                                                        } else if (broker == 'Upstox' && $(row).find('.broker').text() == broker
                                                                && $(row).find('.loginId').text() == loginId && $(row).find('.password').text() == pwd
                                                                && $(row).find('.passcode').text() == passcode) {
                                                            if (id != null && id != '' && $(row).attr('class').split(' ')[0] == id) {
                                                                retVal = false;
                                                            } else {
                                                                retVal = true;
                                                            }
                                                        } else if (broker == 'Ant' && $(row).find('.broker').text() == broker
                                                                && $(row).find('.loginId').text() == loginId && $(row).find('.password').text() == pwd
                                                                && $(row).find('.q1').text() == q1 && $(row).find('.q2').text() == q2) {
                                                            if (id != null && id != '' && $(row).attr('class').split(' ')[0] == id) {
                                                                retVal = false;
                                                            } else {
                                                                retVal = true;
                                                            }
                                                        }
                                                    });
                                                    return retVal;
                                                }
        </script>
    </body>
</html>
