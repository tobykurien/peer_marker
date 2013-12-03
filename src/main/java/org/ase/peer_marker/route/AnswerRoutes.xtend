package org.ase.peer_marker.route

import org.ase.peer_marker.model.Answer
import org.ase.peer_marker.model.Student
import org.ase.peer_marker.transformer.JsonTransformer
import org.javalite.activejdbc.Model
import org.json.JSONObject

import static extension org.ase.peer_marker.Helper.*

class AnswerRoutes extends BaseRoute {
   val answer = Model.with(Answer)
   
   override load() {
      get(
         new JsonTransformer("/api/answers") [ req, res |
            answer.find("student_id = ?", req.student.id).include(Student)
         ])

      get(
         new JsonTransformer("/api/answers/:id") [ req, res |
            answer.findById(req.params("id"))
         ])

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
               ans.get(0).set(
                  "student_id", req.student.id,
                  "assignment_id", j.getLong("assignment"),
                  "content", j.getString("answer")
               )
               ans.get(0).saveIt
            }               

            '''{"success": true}'''
         ])      
   }
   
}