package com.toby.BeltReview.Service;

import java.util.List;
import java.util.Optional;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

import com.toby.BeltReview.Models.Comment;
import com.toby.BeltReview.Models.Event;
import com.toby.BeltReview.Models.User;
import com.toby.BeltReview.Repositories.EventRepository;
import com.toby.BeltReview.Repositories.MessageRepository;
import com.toby.BeltReview.Repositories.UserRepository;




@Service
public class UserService {
    private final UserRepository userRepository;
    private final EventRepository eventRepository;
    private final MessageRepository messageRepository;
    
    public UserService(UserRepository userRepository, EventRepository eventRepository,MessageRepository messageRepository) {
        this.userRepository = userRepository;
        this.eventRepository = eventRepository;
        this.messageRepository = messageRepository;
    }
    
    // register user and hash their password
    public User registerUser(User user) {
        String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        user.setPassword(hashed);
        return userRepository.save(user);
    }
    
    // find user by email
    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }
    
    // find user by id
    public User findUserById(Long id) {
    	Optional<User> u = userRepository.findById(id);
    	
    	if(u.isPresent()) {
            return u.get();
    	} else {
    	    return null;
    	}
    }
    
    // authenticate user
    public boolean authenticateUser(String email, String password) {
        // first find the user by email
        User user = userRepository.findByEmail(email);
        // if we can't find it by email, return false
        if(user == null) {
            return false;
        } else {
            // if the passwords match, return true, else, return false
            if(BCrypt.checkpw(password, user.getPassword())) {
                return true;
            } else {
                return false;
            }
        }
    }
    // finds an event by id
    public Event findEvent(Long id) {
        Optional<Event> optionalEvent = eventRepository.findById(id);
        if(optionalEvent.isPresent()) {
            return optionalEvent.get();
        } else {
            return null;
        }
    }

    //deletes an event
    public void deleteEvent(Long id) {
    	System.out.println("in  delete service");
    	eventRepository.deleteById(id);
    }
    // finds all events in users state
    public List<Event> findEvent(String state) {
         return eventRepository.findByState(state);
  
    }
    //finds all events not in state
    public List<Event> findEventNot(String state) {
        return eventRepository.findByStateNot(state);
 
   }

    // updates an event
    public Event updateEvent(Event event) {
 	   return eventRepository.save(event);
 	   
    }
    public Comment addComment(Comment comment) {
  	   return messageRepository.save(comment);
  	   
     }
    //creates new event
    public Event createEvent(Event event) {
    	System.out.println("in create event service");
        return eventRepository.save(event);
    }
}
