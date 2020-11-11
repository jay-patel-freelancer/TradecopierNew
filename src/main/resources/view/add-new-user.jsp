<%-- 
    Document   : add-new-user
    Created on : Mar 4, 2020, 5:09:17 PM
    Author     : umair
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                            <h2>Add New User</h2>
                        </div>
                        <form role="form" id="new-account">
                            <div class="form-group text-center">
                                <span class="text-danger d-none sin-box"></span>
                            </div>
                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6">
                                    <div class="form-group">
                                        <input type="text" name="first_name" id="first_name" class="form-control input-sm" placeholder="First Name">
                                        <span class="input-error" id="fnErrorMsg">Required field</span>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6">
                                    <div class="form-group">
                                        <input type="text" name="last_name" id="last_name" class="form-control input-sm" placeholder="Last Name">
                                        <span class="input-error" id="lnErrorMsg">Required field</span>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6">
                                    <div class="form-group">
                                        <input type="email" name="email" id="email" class="form-control input-sm" placeholder="Email Address">
                                        <span class="input-error" id="emErrorMsg">Required field</span>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6">
                                    <div class="form-group">
                                        <input type="phone" name="phone" id="phone" class="form-control input-sm" placeholder="Phone Number">
                                        <span class="input-error" id="phErrorMsg">Required field</span>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-xs-6 col-sm-6 col-md-6">
                                    <div class="form-group">
                                        <input type="password" name="password" id="password" class="form-control input-sm" placeholder="Password">
                                        <span class="input-error" id="pErrorMsg">Required field</span>
                                    </div>
                                </div>
                                <div class="col-xs-6 col-sm-6 col-md-6">
                                    <div class="form-group">
                                        <input type="password" name="password_confirmation" id="password_confirmation" class="form-control input-sm" placeholder="Confirm Password">
                                        <span class="input-error" id="cpErrorMsg">Required field</span>
                                    </div>
                                </div>
                            </div>

                            <input type="hidden" name="appName" value="TRADE_COPIER"/>
                            <input type="hidden" name="appRegId" value="12345"/>
                            <input type="hidden" name="deviceId" value="12345"/>
                            <input type="hidden" name="login" value="login"/>

                            <input type="submit" value="Create Now" class="btn btn-info btn-block" id="sub-btn">

                        </form>
                    </div>
                </div>
            </div>

            <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap4.min.js"></script>
        <script>
            alertTimer = null;
            $(function () {
                $('#new-account').submit(function (e) {
                    e.preventDefault();
                    clearTimeout(alertTimer);
                    $('.input-error').hide();
                    $('.has-error').removeClass('has-error');

                    var fname = $("#first_name").val();
                    var lname = $("#last_name").val();
                    var phone = $("#phone").val();
                    var email = $("#email").val();
                    var pwd = $("#password").val();
                    var cpwd = $("#password_confirmation").val();

                    var emailMatcher = /\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/;
                    var phoneMatcher = /\d{10}/;

                    var error = false;

                    if (fname == '' || fname == null) {
                        $('#first_name').parent().addClass('has-error');
                        $('#fnErrorMsg').text('Required field');
                        $('#fnErrorMsg').show();
                        error = true;
                    }
                    if (lname == '' || lname == null) {
                        $('#last_name').parent().addClass('has-error');
                        $('#lnErrorMsg').text('Required field');
                        $('#lnErrorMsg').show();
                        error = true;
                    }
                    if (phone == '' || phone == null) {
                        $('#phone').parent().parent().addClass('has-error');
                        $('#phErrorMsg').text('Required field');
                        $('#phErrorMsg').show();
                        error = true;
                    } else {
                        if (!phoneMatcher.test(phone)) {
                            $('#phone').parent().parent().addClass('has-error');
                            $('#phErrorMsg').text('Invalid phone number');
                            $('#phErrorMsg').show();
                            error = true;
                        }
                    }

                    if (email == '' || email == null) {
                        $('#email').parent().addClass('has-error');
                        $('#emErrorMsg').text('Required field');
                        $('#emErrorMsg').show();
                        error = true;
                    } else {
                        if (!emailMatcher.test(email)) {
                            $('#email').parent().addClass('has-error');
                            $('#emErrorMsg').text('Invalid email');
                            $('#emErrorMsg').show();
                            error = true;
                        }
                    }

                    if (pwd == '' || pwd == null) {
                        $('#password').parent().addClass('has-error');
                        $('#pErrorMsg').text('Required field');
                        $('#pErrorMsg').show();
                        error = true;
                    } else {
                        if (pwd != cpwd) {
                            $('#password_confirmation').parent().addClass('has-error');
                            $('#cpErrorMsg').text('Password mismatch');
                            $('#cpErrorMsg').show();
                            error = true;
                        }
                    }

                    if (!error) {
                        $('input').prop('readonly', 'readonly');
                        $('#sub-btn').prop('disabled', 'disabled');
                        $('#sub-btn').val('Please wait...');
                        $.post('/admin/add-new-user', $(this).serialize(), function (data) {
                            if (data.response == 'already-registered') {
                                $('input').removeAttr('readonly');
                                $('#sub-btn').removeAttr('disabled');
                                $('#sub-btn').val('Create Now');
                                $('.sin-box').removeClass('d-none');
                                $('.sin-box').html(data.message);
                                $('.sin-box').fadeIn();
                                if (data.r_c == 3) {
                                    $('#email').parent().addClass('has-error');
                                    $('#emErrorMsg').text(data.message);
                                    $('#emErrorMsg').show();
                                } else if (data.r_c == 7) {
                                    $('#phone').parent().parent().addClass('has-error');
                                    $('#phErrorMsg').text(data.message);
                                    $('#phErrorMsg').show();
                                }
                                alertTimer = setTimeout(function () {
                                    $('.sin-box').fadeOut();
                                }, 20 * 1000);
                            } else if (data.response == 'success') {
                                $('#sub-btn').val('Account Created');
                                $('.sin-box').removeClass('d-none').removeClass('text-danger').addClass('text-success');
                                $('.sin-box').html('New Account Created. Congrats');
                                alertTimer = setTimeout(function () {
                                    $('input').removeAttr('readonly');
                                    $('#sub-btn').removeAttr('disabled');
                                    $('#sub-btn').val('Create Now');
                                    $('.sin-box').fadeOut();
                                }, 2 * 1000);
                            } else {
                                $('input').removeAttr('readonly');
                                $('#sub-btn').removeAttr('disabled');
                                $('#sub-btn').val('Create Now');
                                $('.sin-box').removeClass('d-none');
                                $('.sin-box').html(data.message);
                                $('.sin-box').fadeIn();
                                alertTimer = setTimeout(function () {
                                    $('.sin-box').fadeOut();
                                }, 20 * 1000);
                            }
                        })
                                .fail(function () {
                                    $('input').removeAttr('readonly');
                                    $('#sub-btn').removeAttr('disabled');
                                    $('#sub-btn').val('Create Now');
                                    $('.sin-box').removeClass('d-none').addClass('text-danger');
                                    $('.sin-box').html('Unable to connect with SERVER. Check Internet.');
                                    $('.sin-box').fadeIn();
                                    alertTimer = setTimeout(function () {
                                        $('.sin-box').fadeOut();
                                    }, 20 * 1000);
                                });
                    }
                });
            });
        </script>
    </body>
</html>
