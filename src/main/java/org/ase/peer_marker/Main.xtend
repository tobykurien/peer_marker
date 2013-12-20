package org.ase.peer_marker

import com.tobykurien.sparkler.db.DatabaseManager
import org.ase.peer_marker.model.Student
import org.ase.peer_marker.route.AnswerRoutes
import org.ase.peer_marker.route.AssignmentRoutes
import org.ase.peer_marker.route.GradingRoutes
import org.ase.peer_marker.route.LoginRoutes
import org.ase.peer_marker.route.MarkingRoutes
import org.ase.peer_marker.route.StudentRoutes
import org.ase.peer_marker.utils.Log
import org.javalite.activejdbc.LogFilter
import spark.servlet.SparkApplication

import static com.tobykurien.sparkler.Sparkler.*

import static extension org.ase.peer_marker.Helper.*
import org.ase.peer_marker.websocket.WebSocketServer
import org.ase.peer_marker.websocket.RouteWebSocket

class Main implements SparkApplication {
   var WebSocketServer webSocketServer
   
   // Initialize server - called from main() or from Servlet container
   override init() {
      Log.i("logger", "Default log level {}", System.getResource("org.slf4j.simpleLogger.defaultLogLevel"))
      LogFilter.setLogExpression("Query\\:.*");
      DatabaseManager.init(Student.package.name) // init db with package containing db models

      val workingDir = System.getProperty("user.dir")
      externalStaticFileLocation(workingDir + "/views/app")

      // Set up site-wide authentication
      before [ req, res, filter |
         if (!req.pathInfo.startsWith("/login")) {
            if (req.student == null) {
               res.redirect("/login")
               filter.haltFilter(401, "Unauthorised")
            }
         }
      ]

      // Homepage
      get("/") [ req, res |
         render("views/app/index.html", #{})
      ]

      get("/socket") [ req, res |
         render("views/app/websocket.html", #{})
      ]

      // Set up app routes      
      new LoginRoutes().load
      new StudentRoutes().load
      new AnswerRoutes().load
      new AssignmentRoutes().load
      new MarkingRoutes().load
      new GradingRoutes().load
      
      // Start the web socket server
      webSocketServer = new WebSocketServer()
      webSocketServer.addWebSocket(RouteWebSocket, "/socket")
      webSocketServer.initialize("0.0.0.0", 4568)
      webSocketServer.start
   }
   
   // Main method for running embedded server
   def static void main(String[] args) {
      new Main().init();
   }
}
