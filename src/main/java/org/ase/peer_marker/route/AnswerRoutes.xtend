package org.ase.peer_marker.route

import org.ase.peer_marker.model.Answer
import org.ase.peer_marker.model.Assignment
import org.ase.peer_marker.transformer.JsonTransformer
import org.javalite.activejdbc.Model
import org.json.JSONObject

import static extension org.ase.peer_marker.Helper.*

import static org.ase.peer_marker.Constants.*

class AnswerRoutes extends BaseRoute {
   val answer = Model.with(Answer)
   val assignment = Model.with(Assignment)
   
   override load() {
      // Get list of answers
      get(
         new JsonTransformer("/api/answers") [ req, res |
            answer.find("student_id = ?", req.student.id).include(Assignment)
         ])

      // Get specific answer
      get(
         new JsonTransformer("/api/answers/:id") [ req, res |
            answer.findById(req.params("id"))
         ])

      // Get currently editing answer
      get(
         new JsonTransformer("/api/answer") [ req, res |
            var assigns = assignment.find("status = ?", STATUS_EDITING)
            if (assigns.length > 0) {
               var ret = answer.where("assignment_id = ?", assigns.get(0).id).toMaps.get(0)
               // include the assignment details into the answer
               ret.put("assignment", assigns.get(0).toMap)
               ret
            } else {
               #{}
            }
         ])
         
      // create or update the current answer
      post(
         new JsonTransformer("/api/answer") [ req, res |
            var j = new JSONObject(req.body)
            var ans = answer.find("student_id = ? and assignment_id = ?",
                           req.student.id, j.getLong("assignment"))
            if (ans.length == 0) {
               // add answer
               answer.createIt(
                  "student_id", req.student.id,
                  "assignment_id", j.getLong("assignment"),
                  "content", j.getString("answer")
               )
            } else {
               // update existing answer
               var a = ans.get(0)
               a.set(
                  "student_id", req.student.id,
                  "assignment_id", j.getLong("assignment"),
                  "content", j.getString("answer")
               )
               a.saveIt
            }               

            // return status of assignment
            var assign = assignment.findById(j.getLong("assignment"))
            #{
               "status" -> assign.getString("status"),
               "time_remaining" -> -1
            }
         ])      
   }
   
}