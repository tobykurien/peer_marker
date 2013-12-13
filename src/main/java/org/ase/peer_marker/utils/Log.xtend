package org.ase.peer_marker.utils

import org.slf4j.Logger
import org.slf4j.LoggerFactory

class Log {
   // one static Logger to improve performance, although you loose configurability
   val static Logger logger = LoggerFactory.getLogger("Peer Marker") 

   // A searchable tag prefix for filtering the log output
   def static tagPrefix(String tag) {
      System.setProperty("org.slf4j.simpleLogger.defaultLogLevel", "debug")
      '''#[«tag»] '''
   }

   def static t(String tag, String message, Object... args) {
      logger.trace(tag.tagPrefix + message, args)
   }

   def static d(String tag, String message, Object... args) {
      logger.debug(tag.tagPrefix  + message, args)
   }

   def static i(String tag, String message, Object... args) {
      logger.info(tag.tagPrefix  + message, args)
   }

   def static w(String tag, String message, Object... args) {
      logger.warn(tag.tagPrefix  + message, args)
   }

   def static t(String tag, String message, Exception e) {
      logger.trace(tag.tagPrefix  + message, e)
   }

   def static d(String tag, String message, Exception e) {
      logger.debug(tag.tagPrefix  + message, e)
   }

   def static i(String tag, String message, Exception e) {
      logger.info(tag.tagPrefix  + message, e)
   }

   def static w(String tag, String message, Exception e) {
      logger.warn(tag.tagPrefix  + message, e)
   }

   def static e(String tag, String message, Exception e) {
      logger.error(tag.tagPrefix  + message, e)
   }
}