package org.ase.peer_marker.route

import org.ase.peer_marker.model.Answer
import org.ase.peer_marker.model.Assignment
import org.ase.peer_marker.transformer.JsonTransformer
import org.javalite.activejdbc.Model

import static org.ase.peer_marker.Constants.*
import org.ase.peer_marker.pairing.PairingFactory
import static extension org.ase.peer_marker.Helper.*

class MarkingRoutes extends BaseRoute {
   val assignment = Model.with(Assignment)
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
               "student_id" -> a.getLong("student_id"),
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
   }

}
