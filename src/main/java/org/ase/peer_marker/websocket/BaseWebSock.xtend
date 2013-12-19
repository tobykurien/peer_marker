package org.ase.peer_marker.websocket

import org.eclipse.jetty.websocket.api.Session
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketConnect
import org.eclipse.jetty.websocket.api.annotations.WebSocket
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketMessage
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketClose
import org.eclipse.jetty.websocket.api.RemoteEndpoint

@WebSocket
class BaseWebSocket {
   protected var RemoteEndpoint remote
   
   @OnWebSocketConnect
   def onConnect(Session session) {
      remote = session.remote
   }
   
   @OnWebSocketMessage
   def onMessage(String message) {
      
   }
   
   @OnWebSocketClose
   def onClose(int statusCode, String reason) {
      
   }
}