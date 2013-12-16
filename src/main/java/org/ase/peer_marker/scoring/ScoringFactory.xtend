package org.ase.peer_marker.scoring

import java.util.List
import org.ase.peer_marker.model.Comparison

/**
 * Factory for multiple implementations of the scoring algorithm to rank the 
 * answers based on the comparisons
 */
abstract class ScoringFactory {
   protected var List<Comparison> comparisons
   
   def static ScoringFactory getInstance(List<Comparison> comparisons) {
      throw new Exception("not yet implemented")
   }
   
   protected new(List<Comparison> comparisons) {
      this.comparisons = comparisons
   }
   
   // Apply the comparisons to arrive at a ranking score for each answer
   def abstract void rankAnswers()
}