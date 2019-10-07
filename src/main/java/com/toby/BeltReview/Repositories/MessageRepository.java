package com.toby.BeltReview.Repositories;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.toby.BeltReview.Models.Comment;

@Repository
public interface MessageRepository extends CrudRepository<Comment, Long> {

}
