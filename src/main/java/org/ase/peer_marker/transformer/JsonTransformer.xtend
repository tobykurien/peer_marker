package org.ase.peer_marker.transformer

import com.tobykurien.sparkler.Helper
import com.tobykurien.sparkler.db.DatabaseManager
import org.javalite.activejdbc.Base
import org.javalite.activejdbc.LazyList
import org.javalite.activejdbc.Model
import spark.Request
import spark.Response
import spark.ResponseTransformerRoute
import com.fasterxml.jackson.databind.ObjectMapper

/**
 * Returns a JSON serialized version of Model objects
 */
class JsonTransformer extends com.tobykurien.sparkler.transformer.JsonTransformer {
   
   new(String path, (Request, Response)=>Object handler) {
      super(path, handler)
   }
   
}
