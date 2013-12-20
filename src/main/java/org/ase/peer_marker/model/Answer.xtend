package org.ase.peer_marker.model

import org.javalite.activejdbc.Model
import org.javalite.activejdbc.annotations.BelongsToParents
import org.javalite.activejdbc.annotations.BelongsTo

@BelongsTo(foreignKeyName="student_id",parent=Student)
class Answer extends Model {
   def Assignment getAssignment() {
      parent(Assignment)
   }

	def getStudentId() {
	   getLong("student_id")
	}
	
	def getScore() {
	   if (getDouble("score") == null) { 0D } else { getDouble("score") }
	}
}