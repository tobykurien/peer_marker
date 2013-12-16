package org.ase.peer_marker.route

import org.ase.peer_marker.grading.GradingFactory
import org.ase.peer_marker.model.Comparison
import org.ase.peer_marker.transformer.JsonTransformer
import org.javalite.activejdbc.Model

class GradingRoutes extends BaseRoute {
   val comparison = Model.with(Comparison)

	override load() {
		get(new JsonTransformer("/api/grading/answers/:assignmentId", [req,res|
		   val comps = comparison.where("assignment_id = ?", req.params("assignmentId"))
			GradingFactory.getInstance(comps).answersForGrading
		]))
	}
	
}