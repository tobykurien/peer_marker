package org.ase.peer_marker.websocket

import java.util.ArrayList
import java.util.List
import org.ase.peer_marker.utils.Log
import org.eclipse.jetty.server.Handler
import org.eclipse.jetty.server.HttpConfiguration
import org.eclipse.jetty.server.HttpConnectionFactory
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.server.ServerConnector
import org.eclipse.jetty.server.handler.ContextHandler
import org.eclipse.jetty.server.handler.HandlerCollection
import org.eclipse.jetty.websocket.server.WebSocketHandler
import org.eclipse.jetty.websocket.servlet.WebSocketServletFactory

/**
 * WebSocket server send messages to the clients
 */
class WebSocketServer {
	var Server server
	val List<Handler> handlers = new ArrayList<Handler>
	public static val webSockets = new ArrayList<BaseWebSocket>

	def initialize(String host, int port) {
		server = new Server

		val httpCon = new HttpConnectionFactory(new HttpConfiguration)
		val conn = new ServerConnector(server, httpCon)
		conn.host = host
		conn.port = port
		server.addConnector(conn)

		val handlerCollection = new HandlerCollection
		handlerCollection.setHandlers(handlers)
		server.setHandler(handlerCollection)
	}

	def start() {
		server.start
		//server.join
	}

	def stop() {
		server.stop
		//server.join
	}

	def addWebSocket(Class<?> webSocket, String pathSpec) {
		val wsHandler = new MyWebSockHandler(webSocket)
		val ch = new ContextHandler
		ch.handler = wsHandler
		ch.contextPath = pathSpec
		handlers.add(wsHandler)
	}
	
	def sendMessage(Class<?> webSocketClass, String message) {
	   webSockets.forEach[sock|
	      if (sock.class.canonicalName.equals(webSocketClass.canonicalName)) {
            sock.sendMessage(message)	         
	      }
	   ]
	}
	
	def getServer(){
		return server;
	}
}

class MyWebSockHandler extends WebSocketHandler {
	val Class<?> webSocket

	new(Class<?> webSocket) {
		this.webSocket = webSocket
	}

	override configure(WebSocketServletFactory factory) {
		factory.register(webSocket)
	}
	
	def getWebSocket() {
	   webSocket
	}
}
