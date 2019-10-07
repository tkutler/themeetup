<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Welcome</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<style>
	.line{
		text-decoration: underline;
	}


</style>	
</head>
<body>
	<nav class="navbar navbar-light" style="background-color: orange;">
			<h2 class = "line">The Meetup.COM Clone</h2>
			<h6>Welcome, <c:out value="${user.email}" /></h6>
			<span class= "logout"><a href="/logout">Logout</a></span>
	</nav>
	<div>
	<h1 class ="line">Events in your State</h1>
	<table class="table table-striped">
	<thead>
	<tr>
	  <th scope="col">Name</th>
      <th scope="col">Date</th>
      <th scope="col">Location</th>
      <th scope="col">Host</th>
      <th scope="col">Action/Status</th>
    </tr>
    </thead>
    
    <c:forEach items="${eventSt}" var="event">
    <tr>
    <td> 
     <a href = "/event/${event.id}"><c:out value="${event.name}"/></a>
     </td>
      <td><c:out value="${event.date}"/></td>
      <td><c:out value="${event.location}"/></td>
      <td><c:out value="${event.host.email}"/></td>
      <c:if test="${event.host.id.equals(user.id) == true}">
     <td>
	    <form action="/delete/${event.id}" method="get">
	    <input type="hidden" name="_method" value="delete">
	    <input type="submit" value="Delete">
		</form>
	    <a href = "/event/${event.id}/edit">Edit</a>        	
	</td>

	</c:if>
	<c:if test="${event.attendees.contains(user)}">
	<td>
		<form:form action="/joinEvent" method="post" modelAttribute="events">
		 <p>
        
        <form:errors path="attendees"/>
        <form:input type="hidden" value="${user.email}" path="attendees"/>
    	</p>
	    
	    
		</form:form>
		</td>
	     </c:if>
	     	<c:if test="${!event.attendees.contains(user)}">
		<td>
		<a href = "/joinEvent/${event.id}">Join</a>
		</td>
	     </c:if>
	     <c:if test="${event.attendees.contains(user)}">
		<td>
		<a href = "/leaveEvent/${event.id}">Cancel</a>
		</td>
	     </c:if>
		     </tr>
      </c:forEach>
    
	

    
    </table>
	
	
	
	</div>
		<div>
	<h1 class = "line">Events in other States</h1>
	<table class="table table-striped">
	<thead>
	<tr>
	  <th scope="col">Name</th>
      <th scope="col">Date</th>
      <th scope="col">Location</th>
      <th scope="col">Host</th>
      <th scope="col">Action/Status</th>
    </tr>
    </thead>
    
    <c:forEach items="${eventNot}" var="event">
    <tr>
      <td> 
     <a href = "/event/${event.id}"><c:out value="${event.name}"/></a>
     </td>
      <td><c:out value="${event.date}"/></td>
      <td><c:out value="${event.location}"/></td>
      <td><c:out value="${event.host.email}"/></td>
      <c:if test="${event.host.id.equals(user.id) == true}">
     <td>
	    <form action="/delete/${event.id}" method="get">
	    <input type="hidden" name="_method" value="delete">
	    <input type="submit" value="Delete">
		</form>
	    <a href = "/event/${event.id}/edit">Edit</a>        	
	</td>
	</c:if>
	<c:if test="${!event.attendees.contains(user)}">
	<td>
	<a href = "/joinEvent/${event.id}">Join</a>
	</td>
     </c:if>
     <c:if test="${event.attendees.contains(user)}">
	<td>
	<a href = "/leaveEvent/${event.id}">Cancel</a>
	     
	</td>
     </c:if>
     </tr>
      </c:forEach>
    
    
    
    </table>
	
	
	
	</div>
	<div>
	<h1 class = "line">Schedule a New Event</h1>
		<form:errors path="events.*"/>
<form:form action="/newEvent" method="post" modelAttribute="events">
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
	</div>
	  <footer class="footer text-center">
    <div class="container">
      <ul class="list-inline mb-5">
        <li class="list-inline-item">
          <a class="social-link rounded-circle text-white mr-3" href="https://www.linkedin.com/in/toby-kutler/" target = "_blank">
              <i class="fab fa-linkedin-in"></i>
          </a>
        </li>
        <li class="list-inline-item">
          <a class="social-link rounded-circle text-white" href="https://github.com/tkutler" target="_blank">
            <i class="icon-social-github"></i>
          </a>
        </li>
      </ul>
      <p class="text-muted small mb-0">Copyright &copy; Toby Kutler 2019</p>
    </div>
  </footer>
	
</body>
</html>