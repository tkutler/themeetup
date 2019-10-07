<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Event</title>
</head>
<body>
<%@ page isErrorPage="true" %>    
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>     
<h1>Edit Event</h1>
<form:form action="/edit/${event.id}" method="post" modelAttribute="event">
    <!-- <input type="hidden" name="_method" value="put"> -->
    <p>
        <form:label path="name">Name</form:label>
        <form:errors path="name"/>
        <form:input path="name"/>
    </p>
    <p>
        <form:label path="date">date</form:label>
        <form:errors path="date"/>
        <form:input type="date" path="date"/>
    </p>
    <p>
        <form:label path="location">Location</form:label>
        <form:errors path="location"/>
        <form:input type="text" path="location"/>
        <form:input type="hidden" path="host" value="${user.id}"/>
    </p>
     <p>
        <form:label path="state">State</form:label>
        <form:errors path="state"/>
        <form:input type="text" path="state"/>
        
    </p>
    
    <input type="submit" value="Submit"/>
    
  
</form:form>

</body>
</html>