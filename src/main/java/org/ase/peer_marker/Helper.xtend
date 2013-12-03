package org.ase.peer_marker

import org.ase.peer_marker.model.Student
import spark.Request

/**
 * Utility extension methods
 */
class Helper {
   // Get the student from the session   
   def static getStudent(Request request) {
      request.session(true).attribute("student") as Student
   }

   // Set the student into the session   
   def static setStudent(Request request, Student student) {
      request.session(true).attribute("student", student)
   }
   
   // Is this user an admin?
   def static isAdmin(Request request) {
      getStudent(request).get("username").equals("teacher")
   }
}