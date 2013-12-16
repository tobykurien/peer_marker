package org.ase.peer_marker

import com.tobykurien.sparkler.test.TestSupport
import org.ase.peer_marker.model.Answer
import org.javalite.activejdbc.Model
import org.junit.Test
import org.ase.peer_marker.grading.GradingFactory
import org.ase.peer_marker.model.Comparison

class GradingTest extends TestSupport {
   val answer = Model.with(Answer)
   val comparison = Model.with(Comparison)
   
   override getModelPackageName() {
      Answer.package.name
   }
   
   @Test
   def shouldReturnAnswersForGrading() {
      var answer1 = answer.createIt(
         "student_id", 1L,
         "assignment_id", 1L,
         "content", "Answer 1",
         "score", 1
      )                   

      var answer2 = answer.createIt(
         "student_id", 1L,
         "assignment_id", 1L,
         "content", "Answer 1",
         "score", 0.5
      )                   

      var answer3 = answer.createIt(
         "student_id", 1L,
         "assignment_id", 1L,
         "content", "Answer 1",
         "score", 0
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
      
      var answers = GradingFactory.getInstance(#[comp1, comp2, comp3]).answersForGrading
      the(answers.length).shouldEqual(2)                         
      the(answers.get(0).id).shouldEqual(answer1.id)                         
      the(answers.get(1).id).shouldEqual(answer3.id)                         
   }
   
}