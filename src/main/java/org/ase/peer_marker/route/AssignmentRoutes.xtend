package org.ase.peer_marker.route

import org.ase.peer_marker.model.Answer
import org.ase.peer_marker.model.Assignment
import org.ase.peer_marker.transformer.JsonTransformer
import org.javalite.activejdbc.Model
import org.json.JSONObject
import spark.Request
import spark.Response

import static org.ase.peer_marker.Constants.*

import static extension org.ase.peer_marker.Helper.*

class AssignmentRoutes extends BaseRoute {
   val assignment = Model.with(Assignment)
   val answer = Model.with(Answer)

   override load() {
      // Get all assignments
      get(
         new JsonTransformer("/api/assignments") [ req, res |
            authenticate(req, res)
            assignment.all.limit(10).orderBy("id desc") // limit to 10 newest
         ])

      // Create a new assignment
      post(
         new JsonTransformer("/api/assignment") [ req, res |
            authenticate(req, res)
            var j = new JSONObject(req.body)
            
            // there should only be one assignment in editing mode
            if (STATUS_EDITING.equalsIgnoreCase(j.getString("status"))) {
               resetEditing
            }
            
            assignment.createIt(
               "name",
               j.getString("name"),
               "question",
               j.getString("question"),
               "status",
               j.getString("status")
            )
         ])

      // Update an assignment
      put(
         new JsonTransformer("/api/assignment/:id") [ req, res |
            authenticate(req, res)
            var j = new JSONObject(req.body)

            if (j.has("status") && STATUS_EDITING.equalsIgnoreCase(j.getString("status"))) {
               resetEditing
            }

            var a = assignment.findById(req.params("id"))
            if (a != null) {
               if (j.has("name")) a.set("name", j.getString("name"))
               if (j.has("question")) a.set("question", j.getString("question"))
               if (j.has("status")) a.set("status", j.getString("status"))               
               a.saveIt
            } else {
               res.status(404)
               throw new Exception("Not found")
            }
         ])

      // get specified assignment
      get(
         new JsonTransformer("/api/assignment/:id") [ req, res |
            assignment.findById(req.params("id"))
         ])

      // get current assignment that is in editing mode
      get(
         new JsonTransformer("/api/assignment") [ req, res |
            var assigns = assignment.find("status = ?", STATUS_EDITING)
            if (assigns.length > 0) {
               assigns.get(0)
            } else {
               #{}
            }
         ])

      // get answers for specified assignment
      get(
         new JsonTransformer("/api/assignment_answers/:id") [ req, res |
            authenticate(req, res)
            answer.find("assignment_id = ?", req.params("id"))
         ])


      // delete specified assignment
      delete(
         new JsonTransformer("/api/assignment/:id") [ req, res |
            authenticate(req, res)
            assignment.delete("id = ?", req.params("id"))
         ])
   }

   // There should only be one assignment in "EDITING" status, so 
   // reset current ones to "COMPLETE"   
   def resetEditing() {
      assignment.find("status = ?", STATUS_EDITING)?.forEach [ a |
         a.set("status", STATUS_COMPLETE)
         a.saveIt()
      ]
   }
   
   // Authenticate that user is a teacher/admin
   def authenticate(Request request, Response response) {
      if (!request.isAdmin) {
         response.status(401)
         throw new Exception("Unauthorised")
      }
   }

}
