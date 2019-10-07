<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Event Info</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<style>
	.info {
		text-align: center;
	

	} 
	.form {
	
		text-align: left;
		background-color: #FFFACD;
	
	}
	.message{
		background-color: grey;
		font-size: 33px;
	
	}
	h1 {
		text-decoration: underline;
	
	}
	.name{
		font-size: 12px;
	
	} 
	.label{
		font-size: 26px;
		
	
	}

	.board {
		text-align: center;
		border: solid orange;
	}

	.logout{
		margin-left: 592px;
	
	}
	.rsvp {
		text-align: center;
	
	}

</style>
</head>
<body>
	<nav class="navbar navbar-light" style="background-color: orange;">
			<h2>The Meetup.COM Clone</h2>
			<span class= "logout"><a href="/logout">Logout</a></span>
			<a href="/home">Back</a>
	</nav>

	
	<div class ="info">   
		<h1><c:out value="${event.name}"/></h1>
		<p>Host: <c:out value="${event.host.email}"/></p>
		<p>Date: <c:out value="${event.date}"/></p>
		<p>Location: <c:out value="${event.location}"/></p>
	</div>
	<div class = "board">
	<h1>Message Board</h1>
	
	<c:forEach items="${comments}" var="comment"> 
	<p class ="message"><c:out value="${comment.message}"/></p>
	<p class = "name"><c:out value="${comment.email}"/></p>
	
	
	</c:forEach> 	
		<div class = "form">
	<form:form action="/newMessage/${event.id}" method="post" modelAttribute="newcomment">
    <p>
        <form:label class= "label" path="message">Your Message:</form:label>
        <form:errors path="message"/>
        <form:input path="message"/>
        <form:input type="hidden" path="email" value = "${user.email}"/>
        <form:input type="hidden" path="event" value = "${event.id}"/>
                
        
    </p>

    
    <input type="submit" value="Post"/>
    
</form:form> 
	
	
	
	</div>
	
	
	</div>
	<div class ="rsvp">
	<h1>Who's Coming</h1>
	<c:forEach items="${attendees}" var="user">	
	<p><c:out value="${user.email}"/></p>
	</c:forEach>
	
	
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