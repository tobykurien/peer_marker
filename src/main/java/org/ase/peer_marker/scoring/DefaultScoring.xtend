package org.ase.peer_marker.scoring

import java.util.List
import org.ase.peer_marker.model.Comparison

class DefaultScoring extends ScoringFactory{
	
	protected new(List<Comparison> comparisons) {
		super(comparisons)
	}
	
	override rankAnswers() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}