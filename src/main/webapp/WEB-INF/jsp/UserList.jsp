<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>User List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
            crossorigin="anonymous"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        body {
            background-color: #343a40;
            color: #f8f9fa;
        }

        /* Navbar Styles */
        .navbar {
            background-color: #1a1e21;
        }
        .navbar-brand {
            color: #f8f9fa;
            font-weight: bold;
        }
        .navbar-toggler-icon {
            background-color: #f8f9fa;
        }
        .navbar-nav .nav-link {
            color: #f8f9fa;
        }
        .navbar-nav .nav-link:hover {
            color: #adb5bd;
        }

        /* Form Styles */
        .search-form {
            margin-top: 20px;
        }
        .search-input {
            background-color: #1a1e21;
            border: none;
            border-bottom: 1px solid #adb5bd;
            color: #f8f9fa;
        }
        .search-input::placeholder {
            color: #6c757d;
        }
        .search-btn {
            background-color: #007bff;
            border: none;
            color: #f8f9fa;
        }
        .search-btn:hover {
            background-color: #0056b3;
        }

        /* Table Styles */
        .table {
            background-color: #2c3034;
            color: #f8f9fa;
        }
        .table th {
            background-color: #1a1e21;
            color: #f8f9fa;
        }

        /* Buttons */
        .btn-primary {
            background-color: #007bff;
            border: none;
        }
        .btn-secondary {
            background-color: #6c757d;
            border: none;
        }
        .btn-success {
            background-color: #28a745;
            border: none;
        }
        .btn-danger {
            background-color: #dc3545;
            border: none;
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
                        </c:if>
                    </ul>
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


<div class="container">
    <form class="search-form">
        <div class="row g-3">
            <div class="col-md-4">

                <input type="text" class="form-control search-input" name="userId" id="userId" placeholder="Search User ID">
            </div>
            <div class="col-md-4">
                <input type="text" class="form-control search-input" name="userName" id="userName" placeholder="Search User Name">
            </div>
            <div class="col-md-2">
                <button class="btn btn-primary search-btn" id="search-btn">Search</button>
            </div>
        </div>
    </form>
    <table class="table mt-3" >
        <thead>
        <tr>
            <th>User ID</th>
            <th>User Name</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody id="userListTableBody">
        <c:forEach var="user" items="${userList}">
            <tr>
                <td>${user.userId}</td>
                <td>${user.userName}</td>
                <td>
                    <a href="/SpringProject/UpdateView/${user.userId}" class="btn btn-success btn-sm">Edit</a>
                    <a href="/SpringProject/deleteUser/${user.userId}" class="btn btn-secondary btn-sm"   onclick="return confirm('Are you sure you want to delete this student\'s record?')">Delete</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div id="searchResults"></div>

</div>


<script>
    $(document).ready(function () {
        // Function to parse query parameters from the URL
        function getQueryParams() {
            var params = {};
            var query = window.location.search.substring(1);
            var pairs = query.split("&");

            for (var i = 0; i < pairs.length; i++) {
                var pair = pairs[i].split("=");
                params[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1]);
            }

            return params;
        }

        // Function to filter the table based on query parameters
        function filterTable() {
            var queryParams = getQueryParams();
            var userIdSearch = queryParams["userId"] ? queryParams["userId"].toLowerCase() : "";
            var userNameSearch = queryParams["userName"] ? queryParams["userName"].toLowerCase() : "";

            $("#userListTableBody tr").each(function () {
                var userId = $(this).find("td:eq(0)").text().toLowerCase();
                var userName = $(this).find("td:eq(1)").text().toLowerCase();

                var userIdMatch = userId.includes(userIdSearch);
                var userNameMatch = userName.includes(userNameSearch);

                if (userIdMatch && userNameMatch) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        }

        // Call filterTable function initially and on search button click
        filterTable();
        $("#search-btn").click(filterTable);
    });
</script>


</body>



</html>