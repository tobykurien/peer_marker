package org.ase.peer_marker.websocket

import com.fasterxml.jackson.databind.ObjectMapper
import org.ase.peer_marker.model.Assignment
import org.ase.peer_marker.utils.Log
import org.eclipse.jetty.websocket.api.Session
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketClose
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketConnect
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketMessage
import org.eclipse.jetty.websocket.api.annotations.WebSocket
import org.javalite.activejdbc.Model
import org.json.JSONObject

import static org.ase.peer_marker.Constants.*
import org.javalite.activejdbc.Base
import org.javalite.activejdbc.DB
import com.tobykurien.sparkler.db.DatabaseManager

@WebSocket
class StudentWebSocket extends BaseWebSocket {
   val assignment = Model.with(Assignment)

	@OnWebSocketConnect
	override onConnect(Session session) {
		super.onConnect(session)		
		Log.i("socket", "got connection in " + this.toString)
	}

	@OnWebSocketMessage
	override onMessage(String message) {
		super.onMessage(message)
		Log.i("socket", "got message " + message)
		var msg = new JSONObject(message)
		if (msg.has("user")) {
		   checkStatus(msg.getJSONObject("user").getString("name"))
		}
	}

   def checkStatus(String username) {
      try {
         Base.open(DatabaseManager.newDataSource)
         var editing = assignment.find("status = ?", STATUS_EDITING)
         if (editing.length > 0) {
            sendMessage(new ObjectMapper().writeValueAsString(#{
               "path" -> "/student/edit"
            }))
         }
      } finally {
         Base.close
      }
   }

	@OnWebSocketClose
	override onClose(int statusCode, String reason) {
		Log.i("socket", "connection closed " + this.toString)
		super.onClose(statusCode, reason)
	}
	
	override sendMessage(String message){
      Log.i("socket", "Sending message: " + this.toString)
		remote.sendString(message)
	}
}
