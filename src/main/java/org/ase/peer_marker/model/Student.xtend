package org.ase.peer_marker.model

import org.javalite.activejdbc.Model

class Student extends Model {
   // Used to distinguish students from teacher/admin
   @Property var String type = "student"; // can be "student" or "teacher"
}