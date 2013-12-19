package org.ase.peer_marker.websocket

import org.ase.peer_marker.websocket.BaseWebSocket
import org.eclipse.jetty.websocket.api.Session
import org.ase.peer_marker.utils.Log

class RouteWebSocket extends BaseWebSocket {
   
   override onConnect(Session session) {
      super.onConnect(session)
      Log.i("socket", "got connection" + this.toString)
      remote.sendString("Helloooo")
      null
   }

   override onMessage(String message) {
      super.onMessage(message)
      Log.i("socket", "got message " + message)
      null
   }
   
   override onClose(int statusCode, String reason) {
      Log.i("socket", "connection closed " + this.toString)
      super.onClose(statusCode, reason)
   }
}