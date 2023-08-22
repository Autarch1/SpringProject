<%@page import="org.springframework.ui.ModelMap"%>
<%@page import="Registration.dao.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>	</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
    <style>
        body {
            background-color: #343a40; /* Dark gray background */
            color: #f8f9fa; /* Light gray text */
        }
        .card {
            background-color: #2c3034; /* Dark gray card background */
            border: 1px solid #454d55; /* Gray border */
        }
        .input-group-text {
            background-color: #2c3034; /* Dark gray input group text background */
            border: 1px solid #454d55; /* Gray border */
            color: #adb5bd; /* Light gray input group text color */
        }
        .form-text {
            color: #6c757d; /* Gray form text */
        }

        .navbar-dark .navbar-nav .nav-link {
            color: #f8f9fa !important; /* Light gray navigation link text */
        }
        .navbar-dark .navbar-toggler-icon {
            background-color: #f8f9fa; /* Light gray navbar toggler icon */
        }
        h3, .form-label, .form-check-label {
            color: #ffffff !important; /* Super bright white text color for headings and labels */
            font-size:1.3rem;
        }
        .form-check-inline {
            margin: 15px; /* Adjust the margin value as needed */
            padding-right : 10px;
        }

        .form-control{
            background-color: transparent; /* Transparent background */
            border: none; /* No border */
            border-radius: 0; /* No border-radius */
            border-bottom: 1px solid #adb5bd; /* Underline with light gray color */
            color: #f8f9fa; /* Light gray text color */
            box-shadow: none; /* No box shadow */
            padding: 0; /* Remove padding */
            height: auto; /* Allow height to adjust to content */
            margin: 0; /* Remove margin */
        }

    </style>

</head>
<body>

<!--  Nav bar start  -->

<!-- Navigation Bar -->

<nav class="navbar navbar-expand-lg navbar-dark bg-success sticky-top">
    <div class="container">
        <a class="navbar-brand" href="#">Student Registration</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
                       aria-expanded="false">
                        Class Management
                    </a>
                    <ul class="dropdown-menu">
                        <c:if test="${isAdmin }">
                            <li><a class="dropdown-item" href="/SpringProject/CourseRegister">Course Registration</a></li>
                        </c:if>
                        <li><a class="dropdown-item" href="/SpringProject/StudentRegister">Student Registration</a></li>
                        <c:if test="${isAdmin }">
                            <li><a class="dropdown-item" href="/SpringProject/StudentList">Student Search</a></li>
                        </c:if>                    </ul>
                </li>
                <c:if test="${isAdmin }">
                    <li class="nav-item">
                        <a class="nav-link" href="/SpringProject/UserList">User Management</a>
                    </li>
                </c:if>
                <c:if test="${currentUser==null }">
                    <li class="nav-item">
                        <a class="nav-link" href="/SpringProject/Login">Login</a>
                    </li>
                </c:if>

                <li class="nav-item">
                    <a class="nav-link" href="/SpringProject/UserProfile">${currentUser.userName }</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/SpringProject/Logout">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Form Section -->
<div class="container mt-5">
    <div class="card p-4">
        <h3 class="text-center mb-4">User Registration</h3>
        <form:form action="/SpringProject/ProcessRegister" modelAttribute="registerBean">

            <div class="mb-3">
                <form:label for="name" class="form-label" path="userId">Id</form:label>
                <form:input type="text" class="form-control" id="id" path="userId"  value="USR${String.format('%03d', nextUserId)}" readonly="true"/>
            </div>
            <div class="mb-3">
                <form:label for="name" class="form-label" path="userName">Name</form:label>
                <form:input type="text" class="form-control" id="name" path="userName" />
            </div>
            <div class="mb-3">
                <form:label for="email" class="form-label" path="userEmail" >Email</form:label>
                <form:input type="email" class="form-control" id="email"  path="userEmail"/>
            </div>
            <div class="mb-3">
                <form:label for="password" class="form-label" path="userPassword">Password</form:label>
                <form:input type="password" class="form-control" id="password" path="userPassword" />
            </div>
            <div class="mb-3">
                <label for="confirmPassword" class="form-label">Confirm Password</label>
                <input type="password" class="form-control" id="confirmPassword" name="cPassword" />
            </div>
            <div class="mb-3">
                <label for="userRole" class="form-label">User Role</label>
                <form:select class="form-select" id="userRole" path="userRole">

                    <option value="2" >Admin</option>
                    <option value="1" selected>User</option>
                </form:select>
            </div>
            <div class="d-grid gap-2">
                <button class="btn btn-primary" type="submit">Submit</button>
                <a href="/SpringProject/Login" class="btn btn-link">Already have an account?</a>
            </div>

            <div class="position-fixed top-0 end-0 p-5 mt-5" style="z-index: 11">
                <div id="error-toasts">
                    <div class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                        <div class="toast-header bg-danger text-white">
                            <strong class="me-auto">Error</strong>
                            <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                        </div>
                        <div class="toast-body">
                            <p class="mb-0">${sameEmail }</p>
                            <p class="mb-0">${insertError }</p>
                            <p class="mb-0">${password }</p>
                            <p class="mb-0">${blank }</p>
                        </div>
                    </div>
                </div>
            </div>
        </form:form>
    </div>
</div>


<!-- Form End -->

</body>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
<script>
    var toastElList = [].slice.call(document.querySelectorAll('.toast'));
    var toastList = toastElList.map(function(toastEl) {
        return new bootstrap.Toast(toastEl, { autohide: false });
    });

    toastList.forEach(function(toast) {
        toast.show();
    });
</script>
</html>