package org.ase.peer_marker

import com.tobykurien.sparkler.test.TestSupport
import org.ase.peer_marker.model.Answer
import org.ase.peer_marker.model.Comparison
import org.ase.peer_marker.scoring.ScoringFactory
import org.javalite.activejdbc.Model
import org.junit.Test
import org.ase.peer_marker.utils.Log

class ScoringTest extends TestSupport {
   val answer = Model.with(Answer)
   val comparison = Model.with(Comparison)
   
   override getModelPackageName() {
      Answer.package.name
   }
   
   @Test
   def shouldScoreAnswers() {
      var answer1 = answer.createIt(
         "student_id", 1L,
         "assignment_id", 1L,
         "content", "Answer 1"
      )                   

      var answer2 = answer.createIt(
         "student_id", 2L,
         "assignment_id", 1L,
         "content", "Answer 2"
      )                   

      var answer3 = answer.createIt(
         "student_id", 3L,
         "assignment_id", 1L,
         "content", "Answer 3"
      )
      
      var comp1 = comparison.createIt(
         "assignment_id", 1L,
         "student_id", 1L,
         "answer1_id", answer2.id,
         "answer2_id", answer3.id,
         "score", -1
      )

      var comp2 = comparison.createIt(
         "assignment_id", 1L,
         "student_id", 2L,
         "answer1_id", answer1.id,
         "answer2_id", answer3.id,
         "score", -1
      )

      var comp3 = comparison.createIt(
         "assignment_id", 1L,
         "student_id", 2L,
         "answer1_id", answer1.id,
         "answer2_id", answer2.id,
         "score", -1
      )
      
      var answers = ScoringFactory.getInstance(#[comp1, comp2, comp3]).rankAnswers
      the(answers.length).shouldEqual(3) 
      //Log.i("scoring", answers.toString)                        
      the(answers.get(0).id).shouldEqual(answer1.id)                         
      the(answers.get(1).id).shouldEqual(answer2.id)                         
      the(answers.get(2).id).shouldEqual(answer3.id)                         
   }
}