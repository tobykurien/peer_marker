package org.ase.peer_marker.route

import com.tobykurien.sparkler.db.DatabaseManager
import org.ase.peer_marker.model.Student
import org.javalite.activejdbc.Base
import org.javalite.activejdbc.Model
import static extension org.ase.peer_marker.Helper.*

class LoginRoutes extends BaseRoute {
   val student = Model.with(Student)
   
   override load() {
      get("/login") [ req, res |
         render("views/app/login.html", #{})
      ]

      post("/login") [ req, res |
         Base.open(DatabaseManager.newDataSource)
         try {
            var username = req.queryParams("username")
            var userid = req.queryParams("userid")
            var courseid = req.queryParams("courseid")

            // create user
            var Student ret
            var s = student.find("username =?", username)
            if (s.length == 0) {
               ret = student.createIt(
                  "username", username,
                  "user_id", userid,
                  "course_id", courseid
               )
            } else {
               ret = s.get(0)
            }

            req.student = ret
            res.redirect("/")
            ""
         } finally {
            Base.close
         }
      ]
   }
   
}