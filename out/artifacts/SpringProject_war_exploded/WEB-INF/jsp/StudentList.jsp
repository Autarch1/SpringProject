<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Student List</title>
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


<div class="container">
    <form class="search-form">
        <div class="row g-3">
            <div class="col-md-4">

                <input type="text" class="form-control search-input" name="userId" id="studentId" placeholder="Search Student ID">
            </div>
            <div class="col-md-4">
                <input type="text" class="form-control search-input" name="userName" id="studentName" placeholder="Search Student Name">
            </div>
            <div class="col-md-2">
                <button class="btn btn-primary search-btn" id="search-btn">Search</button>
            </div>
        </div>
    </form>
    <table class="table mt-4" >
        <thead>
        <tr>
            <th>Student ID</th>
            <th>Student Name</th>
            <th>Course</th>
            <th>Photo</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody id="studentListTable">
        <c:forEach var="stud" items="${studList}">
            <tr>
                <td>${stud.studentId}</td>
                <td>${stud.studentName}</td>
                <td><c:forEach items="${stud.studentAttend }" var="course" varStatus="c">
                        ${course }
                    <c:if test="${not c.last }">, </c:if>
                    </c:forEach>
                </td>
                <td><img src="/SpringProject/studentPhoto?studentId=${stud.studentId}" alt="Student Photo" width="50" height="50"></td>

                <td>
                    <a href="/SpringProject/StudentUpdate/${stud.studentId}" class="btn btn-success btn-sm">Edit</a>
                    <a href="/SpringProject/deleteStudent/${stud.studentId}" class="btn btn-secondary btn-sm">Delete</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div id="searchResults"></div>

</div>

<script>
    $(document).ready(function () {
        function filterTable() {
            var studentId = $("#studentId").val().toLowerCase();
            var studentName = $("#studentName").val().toLowerCase();

            $("#studentListTable tr").each(function () {
                var rowStudentId = $(this).find("td:eq(0)").text().toLowerCase();
                var rowStudentName = $(this).find("td:eq(1)").text().toLowerCase();

                var matchesStudentId = rowStudentId.includes(studentId);
                var matchesStudentName = rowStudentName.includes(studentName);

                if (matchesStudentId && matchesStudentName) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        }

        $("#search-btn").click(function (event) {
            event.preventDefault(); // Prevent form submission
            filterTable();
        });
    });
</script>

<script>
    // JavaScript function to update the student's photo
    function updateStudentPhoto(studentId) {
        var photoContainer = document.getElementById("studentPhotoContainer");
        var img = document.createElement("img");
        img.className = "img-fluid";
        img.alt = "Student Photo";
        img.width = 300;
        img.height = 300;
        img.src = "/SpringProject/studentPhoto?studentId=" + studentId;

        // Remove the existing image (if any)
        while (photoContainer.firstChild) {
            photoContainer.removeChild(photoContainer.firstChild);
        }

        // Append the new image
        photoContainer.appendChild(img);
    }

    // Call the function to update the photo for the selected student
    updateStudentPhoto("${selectedStudent.studentId}");
</script>






</body>



</html>