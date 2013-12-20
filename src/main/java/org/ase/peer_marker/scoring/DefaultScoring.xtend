package org.ase.peer_marker.scoring

import java.util.List
import org.ase.peer_marker.model.Comparison
import org.javalite.activejdbc.Model
import org.ase.peer_marker.model.Answer
import java.io.ObjectOutputStream.PutField

class DefaultScoring extends ScoringFactory{
   val answer = Model.with(Answer)
	
	protected new(List<Comparison> comparisons) {
		super(comparisons)
	}
	
	/**
	 * Return the answers with their score field updated, and in the ranked order
	 * according to the comparisons
	 */
	override rankAnswers() {
	   // work out the score for the answers based on given comparisons
      val allAnswers = answer.where("assignment_id = ?", comparisons.get(0).getLong("assignment_id"))
      allAnswers.orderBy("score desc")
      
      // load answers into hashmap for easy access
      val answers = allAnswers.toMap[ longId ]

	   comparisons.forEach [c|
	      var answer1 = answers.get(c.getLong("answer1_id"))
	      var answer2 = answers.get(c.getLong("answer2_id"))
	      if (answer1 != null && answer2 != null) {
            answer1.set("score", answer1.score - c.score)
            answer2.set("score", answer2.score + c.score)
	      }
	   ]
	   
	   // return answers sorted by score
	   answers.values.sort[a,b| b.score <=> a.score]
	}
	
}