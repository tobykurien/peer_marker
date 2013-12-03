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
}