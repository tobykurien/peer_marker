package org.ase.peer_marker

import org.ase.peer_marker.model.Answer
import org.javalite.activejdbc.Model
import org.junit.Test

class PairingTest extends TestSupport {
   
   @Test
   def shouldPickValidAnswers() {
      var answer = Model.with(Answer)
      
      var ans = answer.create()
      ans.set("student_id", 1L)
      
      a(ans.studentId).shouldBeEqual(1L)
   }
   
}