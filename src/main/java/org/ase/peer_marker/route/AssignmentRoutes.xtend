package org.ase.peer_marker.route

import org.ase.peer_marker.model.Assignment
import org.ase.peer_marker.transformer.JsonTransformer
import org.javalite.activejdbc.Model
import org.json.JSONObject
import spark.Request
import spark.Response

import static extension org.ase.peer_marker.Helper.*

class AssignmentRoutes extends BaseRoute {
   val assignment = Model.with(Assignment)

   override load() {
      get(
         new JsonTransformer("/api/assignments") [ req, res |
            authenticate(req, res)
            assignment.all
         ])

      post(
         new JsonTransformer("/api/assignment") [ req, res |
            authenticate(req, res)
            
            // remove existing editing assignment
            assignment.find("status = ?", "EDITING")?.forEach [ a |
               a.set("status", "DONE")
               a.saveIt()
            ]
            var j = new JSONObject(req.body)
            assignment.createIt(
               "name",
               j.getString("name"),
               "question",
               j.getString("question"),
               "status",
               j.getString("status")
            )
         ])

      put(
         new JsonTransformer("/api/assignment/:id") [ req, res |
            authenticate(req, res)

            var j = new JSONObject(req.body)
            assignment.update(
               "name",
               j.getString("name"),
               "question",
               j.getString("question")
            )
         ])

      get(
         new JsonTransformer("/api/assignment") [ req, res |
            var assigns = assignment.find("status = ?", "EDITING")
            if (assigns.length > 0) {
               assigns.get(0)
            } else {
               #{}
            }
         ])
   }
   
   def authenticate(Request request, Response response) {
      if (!request.isAdmin) {
         response.status(401)
         throw new Exception("Unauthorised")
      }
   }

}
