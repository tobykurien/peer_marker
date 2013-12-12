package org.ase.peer_marker.grading

import java.util.List
import org.ase.peer_marker.model.Answer
import org.ase.peer_marker.model.Comparison

/**
 * Factory for multiple implementations of the grading algorithm to grade the 
 * answers based on the comparisons
 */
abstract class GradingFactory {
   protected var List<Comparison> comparisons
   
   def static GradingFactory getInstance(List<Comparison> comparisons) {
      throw new Exception("not yet implemented")
   }
   
   protected new(List<Comparison> comparisons) {
      this.comparisons = comparisons
   }
   
   // Returns a subset of comparisons for the teacher to grade
   def abstract List<Comparison> getComparisonsForGrading() 
   
   // Extrapolate grades supplied by teacher to all answers
   def abstract void applyGrading(long[] comparisonIds,  float[] grades) 
}