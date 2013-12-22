package org.ase.peer_marker.websocket

import com.fasterxml.jackson.databind.ObjectMapper
import org.ase.peer_marker.utils.Log
import org.eclipse.jetty.websocket.api.Session
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketClose
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketConnect
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketMessage
import org.eclipse.jetty.websocket.api.annotations.WebSocket

@WebSocket
class StudentWebSocket extends BaseWebSocket {

	@OnWebSocketConnect
	override onConnect(Session session) {
		super.onConnect(session)
		Log.i("socket", "got connection" + this.toString)
		remote.sendString("Client " + session.localAddress + " connected!")
	}

	@OnWebSocketMessage
	override onMessage(String message) {
		super.onMessage(message)
		Log.i("socket", "got message " + message)
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
