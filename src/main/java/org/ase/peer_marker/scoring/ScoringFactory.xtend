package org.ase.peer_marker.scoring

import java.util.List
import org.ase.peer_marker.model.Answer
import org.ase.peer_marker.model.Comparison

/**
 * Factory for multiple implementations of the scoring algorithm to rank the 
 * answers based on the comparisons
 */
abstract class ScoringFactory {
   protected var List<Comparison> comparisons
   
   new(List<Comparison> comparisons) {
      this.comparisons = comparisons
   }
   
   def abstract List<Answer> getRanking() 
}