package org.ase.peer_marker.model

import org.javalite.activejdbc.Model
import org.javalite.activejdbc.annotations.BelongsToParents
import org.javalite.activejdbc.annotations.BelongsTo

@BelongsTo(foreignKeyName="assignment_id",parent=Assignment)
class Answer extends Model {
	def Student getStudent() {
	   parent(Student)
	}
	
	def getStudentId() {
	   getLong("student_id")
	}
}