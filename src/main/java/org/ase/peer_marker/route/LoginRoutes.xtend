package org.ase.peer_marker.route

import com.tobykurien.sparkler.db.DatabaseManager
import org.ase.peer_marker.model.Student
import org.javalite.activejdbc.Base
import org.javalite.activejdbc.Model

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

            // create user
            var Student ret
            var s = student.find("username =?", username)
            if (s.length == 0) {
               ret = student.createIt(
                  "username",
                  username
               )
            } else {
               ret = s.get(0)
            }

            req.session(true).attribute("student", ret)
            res.redirect("/")
            ""
         } finally {
            Base.close
         }
      ]
   }
   
}