package org.ase.peer_marker

import org.ase.peer_marker.model.Student
import spark.Request

class Helper {
   def static getStudent(Request request) {
      request.session(true).attribute("student") as Student
   }
}