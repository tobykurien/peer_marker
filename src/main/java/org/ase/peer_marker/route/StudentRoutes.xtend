package org.ase.peer_marker.route

import org.ase.peer_marker.model.Student
import org.ase.peer_marker.transformer.JsonTransformer
import org.javalite.activejdbc.Model

import static extension org.ase.peer_marker.Helper.*

class StudentRoutes extends BaseRoute {
   val student = Model.with(Student)
   
   override load() {
      get(
         new JsonTransformer("/api/students") [ req, res |
            student.all;
         ])

      get("/api/user") [ req, res |
         var user = req.student
         if(user.get("username").equals("teacher")) user.type = "teacher"
         '''{ "name": "«user.get("username")»", "type" : "«user.type»"}'''
      ]      
   }
   
}