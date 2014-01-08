package org.ase.peer_marker.websocket

import org.eclipse.jetty.websocket.api.RemoteEndpoint
import org.eclipse.jetty.websocket.api.Session
import org.eclipse.jetty.websocket.server.WebSocketHandler

abstract class BaseWebSocket {
   protected var RemoteEndpoint remote
   protected var Session session
   
   def void onConnect(Session session) {
      this.session = session
      remote = session.remote
      WebSocketServer.webSockets.add(this)
   }
   
   
   def void onMessage(String message) {
   }
   
   
   def  void onClose(int statusCode, String reason) {
      WebSocketServer.webSockets.remove(this)
   }
   
   abstract def void sendMessage(String message);
}