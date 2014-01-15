package org.ase.peer_marker.route

import com.tobykurien.sparkler.db.DatabaseManager
import org.ase.peer_marker.model.Student
import org.javalite.activejdbc.Base
import org.javalite.activejdbc.Model
import spark.Request

import static extension org.ase.peer_marker.Helper.*

class LoginRoutes extends BaseRoute {
   val student = Model.with(Student)
   
   override load() {
      get("/login") [ req, res |
         if (req.queryParams("username") == null) {
            render("views/app/login.html", #{})
         } else {
            doLogin(req)
            res.redirect("/")
            ""
         }
      ]

      post("/login") [ req, res |
         doLogin(req)
         res.redirect("/")
         ""
      ]
   }

   def doLogin(Request req) {
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
      } finally {
         Base.close
      }
   }   
}