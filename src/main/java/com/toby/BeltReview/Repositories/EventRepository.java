package com.toby.BeltReview.Repositories;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.toby.BeltReview.Models.Event;

@Repository
public interface EventRepository extends CrudRepository<Event, Long> {
	List<Event> findByState(String state);
	List<Event> findByStateNot(String state);
}
	