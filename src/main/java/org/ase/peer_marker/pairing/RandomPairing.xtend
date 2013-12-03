package org.ase.peer_marker.pairing

import java.util.List
import org.ase.peer_marker.model.Answer

class RandomPairing extends PairingFactory {
   var picks = 0  // count of picks to avoid infinite loops
   
   new(List<Answer> answers) {
      super(answers)
   }
   
   override getPair(long studentId) {
      var Answer ans1 = pickOne
      while (!validateAnswer(ans1, studentId)) ans1 = pickOne
      System.out.println("First answer: " + ans1.studentId)
      
      var Answer ans2 = pickOne
      while (!validateAnswer(ans2, studentId)) ans2 = pickOne
      System.out.println("Second answer: " + ans2.studentId)

      while (!validatePair(ans1, ans2, studentId)) {
         ans2 = pickOne
         System.out.println("Second answer again: " + ans2.studentId)
      }
      
      #[ans1, ans2]
   }

   def Answer pickOne() {
      picks = picks + 1
      if (picks > answers.length * 3) {
         throw new IllegalStateException("Unable to find a valid pair after " + picks + " tries.")
      }
      
      answers.get(Math.floor(Math.random * answers.length) as int)
   }   
}