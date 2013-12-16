package org.ase.peer_marker.model

import org.javalite.activejdbc.Model
import org.javalite.activejdbc.annotations.BelongsToParents
import org.javalite.activejdbc.annotations.BelongsTo

@BelongsToParents(#[
   @BelongsTo(parent=Answer, foreignKeyName="answer1_id"),
   @BelongsTo(parent=Student, foreignKeyName="student_id")
])
class Comparison extends Model {
   
}