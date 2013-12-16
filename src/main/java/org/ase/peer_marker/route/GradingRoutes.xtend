package org.ase.peer_marker.route

import org.ase.peer_marker.model.Comparison
import org.javalite.activejdbc.Model

class GradingRoutes extends BaseRoute {
	
	val comparisons = Model.with(Comparison)

	override load() {
		get("/api/grading/answers/:assignmentId")[req,res|
//			val query = Base.findAll('''
//				select comparisons.id from comparisions, answers 
//				where (comparisons.answer1_id = answers.id 
//				or answer2_id = answers.id) and answers.assignment_id = ?
//			''', req.params("assignmentId"))
//			GradingFactory.getInstance(comparisons.)
		]
	}
	
}