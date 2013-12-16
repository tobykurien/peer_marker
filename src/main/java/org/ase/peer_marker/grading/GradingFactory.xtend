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
      new BestWorstGrading(comparisons)
   }
   
   protected new(List<Comparison> comparisons) {
      this.comparisons = comparisons
   }
   
   def abstract List<Answer> getAnswersForGrading()
   
   // Extrapolate grades supplied by teacher to all answers
   def abstract void applyGrading(long[] answerIds,  float[] grades) 
}