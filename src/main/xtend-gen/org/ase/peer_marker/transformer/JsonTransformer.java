package org.ase.peer_marker.transformer;

import org.eclipse.xtext.xbase.lib.Functions.Function2;
import spark.Request;
import spark.Response;

/**
 * Returns a JSON serialized version of Model objects
 */
@SuppressWarnings("all")
public class JsonTransformer extends com.tobykurien.sparkler.transformer.JsonTransformer {
  public JsonTransformer(final String path, final Function2<? super Request,? super Response,? extends Object> handler) {
    super(path, handler);
  }
}
