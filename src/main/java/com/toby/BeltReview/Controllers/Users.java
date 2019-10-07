package com.toby.BeltReview.Controllers;

import java.util.List;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.toby.BeltReview.Models.Comment;
import com.toby.BeltReview.Models.Event;
import com.toby.BeltReview.Models.User;
import com.toby.BeltReview.Service.UserService;
import com.toby.BeltReview.Validator.UserValidator;



@Controller
public class Users {
    private final UserService userService;
    
    // NEW
    private final UserValidator userValidator;
    
    // NEW
    public Users(UserService userService, UserValidator userValidator) {
        this.userService = userService;
        this.userValidator = userValidator;
    }
    

    @RequestMapping("/")
    public String registerForm(@ModelAttribute("user") User user) {
        return "LoginRegistrationPage.jsp";
    }

    
    @RequestMapping(value="/registration", method=RequestMethod.POST)
    public String registerUser(@Valid @ModelAttribute("user") User user, BindingResult result, HttpSession session) {
    	userValidator.validate(user, result);
    	if(result.hasErrors()) {
    		return "LoginRegistrationPage.jsp";
    	}
    	User u = userService.registerUser(user);
    	session.setAttribute("userId", u.getId());
    	return "redirect:/home";
    }
    
    @RequestMapping(value="/login", method=RequestMethod.POST)
    public String loginUser(@RequestParam("email") String email, @RequestParam("password") String password, Model model, HttpSession session) {
        // if the user is authenticated, save their user id in session
        // else, add error messages and return the login page
    	boolean isAuthenicated = userService.authenticateUser(email,password);
    	if(isAuthenicated) {
    		User u = userService.findByEmail(email);
    		session.setAttribute("userId", u.getId());
    		return "redirect:/home";
    			
    	} else  {
    		System.out.println("ERRRRRRORRRRR");
    		model.addAttribute("error", "Invalid Crendentials. Please try again.");
    		return "LoginRegistrationPage.jsp";
    	}

    } 
    
    //to dash-board page
    @RequestMapping("/home")
    public String home(HttpSession session, Model model, @ModelAttribute("events") Event event) {
        // get user from session, save them in the model and return the home page
    	Long userId = (Long) session.getAttribute("userId");
    	User u = userService.findUserById(userId);
    	model.addAttribute("user", u);
    	String state = u.getState();
    	model.addAttribute("userState", state);
    	List <Event> eventInState = userService.findEvent(state);
    	model.addAttribute("eventSt", eventInState);
    	List <Event> eventNotInState = userService.findEventNot(state);
    	model.addAttribute("eventNot", eventNotInState);
    	return "homePage.jsp";
    } 
    
    //creates new event
    @RequestMapping(value="/newEvent", method=RequestMethod.POST)
    public String create(@Valid @ModelAttribute("events") Event event, BindingResult result) {
        if (result.hasErrors()) {
        	System.out.println("ERROR");
            return "/homePage.jsp";
        } else
        	System.out.println(event.getDate());
        	System.out.println(event);
            userService.createEvent(event);
            return "redirect:/home";
        }
    //deletes an event
    @RequestMapping(value="/delete/{id}", method=RequestMethod.POST)
    public String destroy(@PathVariable("id") Long id) {
    	System.out.println("in destroy control");
        userService.deleteEvent(id);
        return "redirect:/home";
    }
    // to event update page
    @RequestMapping("/event/{id}/edit")
    public String edit(@ModelAttribute("event") Event event,@PathVariable("id") Long id, Model model) {
        Event e = userService.findEvent(id);
        model.addAttribute("event", e);
        return "edit.jsp";
    }
    // makes event edit
    @RequestMapping(value="/edit/{id}", method=RequestMethod.POST)
    public String update(@Valid @ModelAttribute("event") Event event, BindingResult result) {
        if (result.hasErrors()) {
            return "edit.jsp";
        } else {
            userService.updateEvent(event);
            return "redirect:/home";
        }
    } 
    // makes new message
    @RequestMapping(value="/newMessage/{id}", method=RequestMethod.POST)
    public String Newmessage(HttpSession session, User user, @PathVariable ("id")Long id, @Valid @ModelAttribute("newcomment") Comment comment, BindingResult result, Model model) {
        if (result.hasErrors()) {
            return "EventInfo.jsp";
        } else {
        	user =userService.findUserById((Long) session.getAttribute("userId"));
        	
        	comment.setId(null);
        	Event e = userService.findEvent(id);
        	comment.setEvent(e);
        	Comment m = userService.addComment(comment);
        	
        	e.getComments().add(m);
//            userService.addComment(comment);
            userService.createEvent(e);
            
            System.out.println(comment);
            System.out.println(e.getComments());
            
            
            return "redirect:/event/{id}";
        }
    } 
    //joins user to an event
    @RequestMapping(value="/joinEvent/{id}")
    public String join( @PathVariable ("id") Long id, HttpSession session) {
    	Long userId = (Long) session.getAttribute("userId");
    	User u = userService.findUserById(userId);
    	Event e = userService.findEvent(id);
    	e.getAttendees().add(u);
    	userService.createEvent(e);
    	System.out.println(e.getAttendees());
    	return "redirect:/home";
    
    }
    //removes user from an event
    @RequestMapping(value="/leaveEvent/{id}")
    public String remove( @PathVariable ("id") Long id, HttpSession session) {
    	Long userId = (Long) session.getAttribute("userId");
    	User u = userService.findUserById(userId);
    	Event e = userService.findEvent(id);
    	e.getAttendees().remove(u);
    	userService.createEvent(e);
    	System.out.println(e.getAttendees());
    	return "redirect:/home";
    
    }
    //to event page 
    @RequestMapping(value="/event/{id}", method=RequestMethod.GET)
    public String show(@ModelAttribute("newcomment") Comment evt,Model model, @PathVariable(value="id") Long id,HttpSession session) {
    	Long userId = (Long) session.getAttribute("userId");
    	User u = userService.findUserById(userId);
    	model.addAttribute("user", u);
    	Event event = userService.findEvent(id);
    	model.addAttribute("event", event);
    	List <User> attendees = event.getAttendees();
    	model.addAttribute("attendees", attendees);
    	List<Comment> comments = event.getComments();
    	model.addAttribute("comments", comments);
    	model.addAttribute("newcomment",new Comment());
    	return "EventInfo.jsp";
    }
    
    

    //logout user
    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        // invalidate session
        // redirect to login page
    	session.invalidate();
    	return "redirect:/";
    }
}
