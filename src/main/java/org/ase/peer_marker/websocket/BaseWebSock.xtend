package org.ase.peer_marker.websocket

import org.eclipse.jetty.websocket.api.RemoteEndpoint
import org.eclipse.jetty.websocket.api.Session

class BaseWebSocket {
   protected var RemoteEndpoint remote
   
   
   def void onConnect(Session session) {
      remote = session.remote
   }
   
   
   def void onMessage(String message) {
      
   }
   
   
   def  void onClose(int statusCode, String reason) {
      
   }
}