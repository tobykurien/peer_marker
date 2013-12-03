package org.ase.peer_marker.pairing

import java.util.List
import org.ase.peer_marker.model.Answer

class RandomPairing extends PairingFactory {
   
   new(List<Answer> answers) {
      super(answers)
   }
   
   override getPair(long studentId) {
      var Answer ans1 = pickOne(studentId, -1)
      var Answer ans2 = pickOne(studentId, ans1.id as Long)
      
      #[ans1, ans2]
   }

   def Answer pickOne(long studentId, long answerId) {
      var Answer ret = null
      
      while (ret == null || ret.getLong("student_id") != studentId || ret.id == answerId) {
         ret = answers.get(Math.floor(Math.random * answers.length) as int)
      }
      
      ret
   }   
}