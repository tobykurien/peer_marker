package org.ase.peer_marker.pairing

import java.util.List
import org.ase.peer_marker.model.Answer

/**
 * Factory for multiple implementations of algorithms to pair the 
 * pool of answers in a fair manner
 */
abstract class PairingFactory {
   protected var List<Answer> answers
   
   new(List<Answer> answers) {
      this.answers = answers
   }
   
   /**
    * Returns a list with 2 Answer objects to be compared. The answers must 
    * not belong to the specified student
    */
   def abstract List<Answer> getPair(long studentId)
   
   /**
    * Check if the pair is valid
    */
   def boolean validatePair(Answer answer1, Answer answer2, long studentId) {
      if (answer1 == null) return false
      if (answer2 == null) return false
      if (answer1.id == answer2.id) return false
      
      if (answer1.studentId == studentId ||
          answer2.studentId == studentId) {
             return false
      }
      
      return true
   }

   /**
    * Check if the selection is valid
    */
   def boolean validateAnswer(Answer answer, long studentId) {
      if (answer == null || answer.studentId == studentId) return false
      
      return true
   }
}