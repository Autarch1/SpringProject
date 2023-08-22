<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Student Register</title>

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
<div class="container mt-5 ">
    <div class="card p-4">
        <h3 class="text-center mb-4">Student Registration</h3>
        <form:form action="/SpringProject/StudentRegisterProcess" modelAttribute="studentBean" enctype="multipart/form-data" >
            <div class="mb-3">
                <form:label for="studentId" class="form-label" path="studentId">Student Id</form:label>
                <form:input type="text" class="form-control" id="studentId" path="studentId" value="STU${String.format('%03d', nextStudentId)}" readonly="true"/>
            </div>
            <div class="mb-3">
                <form:label for="studentName" class="form-label" path="studentName">Student Name</form:label>
                <form:input type="text" class="form-control" path="studentName" />
            </div>
            <div class="mb-3">
                <form:label for="studentDob" class="form-label" path="studentDob">DOB</form:label>
                <form:input type="date" class="form-control" path="studentDob" />
            </div>
            <div class="mb-3">
                <label class="form-label">Gender</label>
                <div class="form-check form-check-inline">
                    <form:radiobutton path="studentGender" id="male" value="Male" class="form-check-input" />
                    <label class="form-check-label" for="male">Male</label>
                </div>
                <div class="form-check form-check-inline">
                    <form:radiobutton path="studentGender" id="female" value="Female" class="form-check-input" />
                    <label class="form-check-label" for="female">Female</label>
                </div>
            </div>

            <div class="mb-3">
                <form:label for="phone" class="form-label" path="studentPhone">Phone</form:label>
                <div class="input-group">
                    <span class="input-group-text">+95</span>
                    <form:input type="text" class="form-control" pattern="^(\+95\s)?\d{10}$" id="phone" path="studentPhone" />
                </div>
                <div class="form-text">Enter a 9-digit phone number (excluding the prefix).</div>
            </div>

            <div class="mb-3">
                <form:label for="studentEducation" class="form-label" path="studentEducation">Education</form:label>
                <form:select class="form-select" path="studentEducation">
                    <form:option value="Bachelor of Information Technology" label="Bachelor of Information Technology" />
                    <form:option value="Diploma in IT" label="Diploma in IT" />
                    <form:option value="Bachelor of Computer Science" label="Bachelor of Computer Science" />
                </form:select>
            </div>

            <div class="mb-3">
                <label class="form-label">Attend</label>
                <div class="form-check">
                    <c:forEach items="${cList}" var="course">
                        <div class="form-check-inline">
                            <form:checkbox path="studentAttend" value="${course.courseName } " class="form-check-input" />
                            <label class="form-check-label" >${course.courseName }</label>
                        </div>
                    </c:forEach>
                </div>
            </div>


            <div class="mb-3">
                <label class="form-label" path="studentPhoto">Photo</label>
                <input type="file" class="form-control" name="studentPhoto" accept="image/*" />
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
                            <p class="mb-0">${Dup }</p>
                            <p class="mb-0">${fail }</p>
                            <p class="mb-0">${blank }</p>
                        </div>
                    </div>
                </div>
            </div>
        </form:form>
    </div>
</div>
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