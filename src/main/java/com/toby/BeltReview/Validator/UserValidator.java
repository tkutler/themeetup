package com.toby.BeltReview.Validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.toby.BeltReview.Models.User;

@Component
public class UserValidator implements Validator {
    
    // 1
    @Override
    public boolean supports(Class<?> clazz) {
        return User.class.equals(clazz);
    }
    
    // 2
    @Override
    public void validate(Object target, Errors errors) {
        User user = (User) target;
        
        if (!user.getPasswordConfirmation().equals(user.getPassword())) {
            // 
            errors.rejectValue("passwordConfirmation", "Match");
        }         
    }
}
