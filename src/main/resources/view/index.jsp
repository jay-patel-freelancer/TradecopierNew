<%-- 
    Document   : index
    Created on : Mar 4, 2020, 2:41:50 PM
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
        <link href="${pageContext.request.contextPath}/resources/css/theme.css?ver=160" rel="stylesheet" type="text/css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    </head>
    <body class="smoke">
        <div class="container">
            <div class="card card-login mx-auto text-center bg-dark">
                <div class="card-header mx-auto bg-dark">
                    <span> <img src="${pageContext.request.contextPath}/resources/images/logo.png" class="w-75" alt="Trade Copier"> </span><br/>
                </div>
                <div class="card-body">
                    <form method="post" class="log-form">
                        <div class="form-group text-center">
                            <span class="text-danger d-none log-box"></span>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"><i class="fa fa-envelope"></i></span>
                                </div>
                                <input type="text" name="email" id="email" class="form-control" placeholder="Email">
                            </div>
                            <span class="input-error" id="emailErrorMsg">Required field</span>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"><i class="fa fa-key"></i></span>
                                </div>
                                <input type="password" name="password" id="password" class="form-control" placeholder="Password">
                            </div>
                            <span class="input-error" id="pwdErrorMsg">Required field</span>
                        </div>
                        <div class="row">
                            <div class="col-md-7">
                            </div>
                            <div class="col-md-5">
                                <div class="form-group">
                                    <input type="submit" name="btn" value="Login" class="btn btn-outline-danger float-right login_btn">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap4.min.js"></script>
        <script>
            alertTimer = null;
            $(function () {
                $('.log-form').submit(function (e) {
                    e.preventDefault();
                    clearTimeout(alertTimer);
                    $('.log-box').hide();
                    $('.input-error').hide();
                    $('.has-error').removeClass('has-error');

                    var email = $("#email").val();
                    var pwd = $("#password").val();

                    var emailMatcher = /\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/;
                    var error = false;

                    if (email == '' || email == null) {
                        $('#email').parent().addClass('has-error');
                        $('#emailErrorMsg').text('Required field');
                        $('#emailErrorMsg').show();
                        error = true;
                    } else {
                        if (!emailMatcher.test(email)) {
                            $('#email').parent().addClass('has-error');
                            $('#emailErrorMsg').text('Invalid email');
                            $('#emailErrorMsg').show();
                            error = true;
                        }
                    }

                    if (pwd == '' || pwd == null) {
                        $('#password').parent().addClass('has-error');
                        $('#pwdErrorMsg').text('Required field');
                        $('#pwdErrorMsg').show();
                        error = true;
                    }
                    if (!error) {
                        $('input').prop('readonly', 'readonly');
                        $('.login_btn').prop('disabled', 'disabled');
                        $('.login_btn').val('Please wait...');
                        $.post('/login', $(this).serialize(), function (data) {
                            if (data.success) {
                                $('.login_btn').val('Login Success');
                                alertTimer = setTimeout(function () {
                                    location.href = data.redirect;
                                }, 1.5 * 1000);
                            } else {
                                $('input').removeAttr('readonly');
                                $('.login_btn').removeAttr('disabled');
                                $('.login_btn').val('Login');
                                $('.log-box').removeClass('d-none');
                                $('.log-box').html(data.message);
                                $('.log-box').fadeIn();
                                alertTimer = setTimeout(function () {
                                    $('.log-box').fadeOut();
                                }, 20 * 1000);
                            }
                        });
                    }
                });
            });
        </script>
    </body>
</html>
