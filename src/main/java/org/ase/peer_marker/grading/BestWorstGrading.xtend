package org.ase.peer_marker.grading

import java.util.List
import org.ase.peer_marker.model.Answer
import org.ase.peer_marker.model.Comparison
import org.javalite.activejdbc.Model

class BestWorstGrading extends GradingFactory {
	val answer = Model.with(Answer)

	protected new(List<Comparison> comparisons) {
		super(comparisons)
	}

	override getAnswersForGrading() {

		//		comparisons.sort[a,b|
		//			if (a.score == b.score) {
		//				0
		//			} else if (a.score < b.score) {
		//				-1
		//			}else{
		//				1
		//			}
		//		]
		val res = answer.findAll.orderBy("score asc")
		#[
			res.first,
			res.last
		]

	}

	def first(Iterable<Answer> iter) {
		iter.take(1).get(0)
	}
	
	override applyGrading(long[] comparisonIds, float[] grades) {
	}

}
