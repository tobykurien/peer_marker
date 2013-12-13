package org.ase.peer_marker.route

import org.ase.peer_marker.model.Answer
import org.ase.peer_marker.model.Assignment
import org.ase.peer_marker.model.Comparison
import org.ase.peer_marker.model.Evaluation
import org.ase.peer_marker.pairing.PairingFactory
import org.ase.peer_marker.transformer.JsonTransformer
import org.javalite.activejdbc.Model
import org.json.JSONObject

import static org.ase.peer_marker.Constants.*

import static extension org.ase.peer_marker.Helper.*
import org.ase.peer_marker.utils.Log

/**
 * Routes used during the peer marking phase
 */
class MarkingRoutes extends BaseRoute {
   val assignment = Model.with(Assignment)
   val evaluation = Model.with(Evaluation)
   val comparison = Model.with(Comparison)
   val answer = Model.with(Answer)
   
   override load() {
      // Current assignment for marking
      get(new JsonTransformer("/api/mark") [ req, res |
         var assign = assignment.findFirst("status = ?", STATUS_MARKING)
         if (assign != null) {
            #{ "assignment" -> assign.toMap }
         } else {
            #{}
         }
      ])

      // Get a pair of answers for marking
      get(new JsonTransformer("/api/mark/pair") [ req, res |
         val assign = assignment.findFirst("status = ?", STATUS_MARKING)
         val answers = answer.where("assignment_id = ?", assign.id)
         val pairing = PairingFactory.getInstance(answers)
         pairing.getPair(req.student.longId).map [a|
            #{
               "id" -> a.longId,
               //"student_id" -> a.getLong("student_id"),
               "assignment_id" -> a.getLong("assignment_id"),
               "content" -> a.getString("content")
             }
         ]
      ])

      // Current marking progress
      get(new JsonTransformer("/api/marking") [ req, res |
         AssignmentRoutes.authenticate(req, res)
         #[
            #{"answers" -> 5, "evaluations" -> 0}, 
            #{"answers" -> 1, "evaluations" -> 1}
         ]
      ])
      
      // Create a new evaluation
      post(
         new JsonTransformer("/api/marking") [ req, res |
            var j = new JSONObject(req.body)
            Log.i("marking", req.body)
//            comparison.createIt(
//            )
//
//            evaluation.createIt(
//            )
//
//            evaluation.createIt(
//            )

              #{ "success" -> true }
         ])

   }

}
