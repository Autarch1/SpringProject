<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Insert title here</title>
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

</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>

</html>