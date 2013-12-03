package org.ase.peer_marker

import com.tobykurien.sparkler.test.TestSupport
import org.ase.peer_marker.model.Answer
import org.javalite.activejdbc.Model
import org.junit.Test

class PairingTest extends TestSupport {
   val answer = Model.with(Answer)
   
   override getModelPackageName() {
      Answer.package.name
   }
   
   @Test
   def shouldPickValidAnswers() {
      
      var ans = answer.create()
      ans.set("student_id", 1L)
      
      a(ans.studentId).shouldBeEqual(1L)
   }
   
   @Test
   def shouldBeEmpty() {
      a(answer.findAll.length).shouldBeEqual(0)
   }
   
}