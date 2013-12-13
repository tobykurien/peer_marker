package org.ase.peer_marker.utils

import org.slf4j.Logger
import org.slf4j.LoggerFactory

class Log {
   val static Logger logger = LoggerFactory.getLogger("") 

   def static t(String tag, String message, Object... args) {
      logger.trace("[" + tag + "] " + message, args)
   }

   def static d(String tag, String message, Object... args) {
      logger.debug("[" + tag + "] " + message, args)
   }

   def static i(String tag, String message, Object... args) {
      logger.info("[" + tag + "] " + message, args)
   }

   def static w(String tag, String message, Object... args) {
      logger.warn("[" + tag + "] " + message, args)
   }

   def static t(String tag, String message, Exception e) {
      logger.trace("[" + tag + "] " + message, e)
   }

   def static d(String tag, String message, Exception e) {
      logger.debug("[" + tag + "] " + message, e)
   }

   def static i(String tag, String message, Exception e) {
      logger.info("[" + tag + "] " + message, e)
   }

   def static w(String tag, String message, Exception e) {
      logger.warn("[" + tag + "] " + message, e)
   }

   def static e(String tag, String message, Exception e) {
      logger.error("[" + tag + "] " + message, e)
   }
}