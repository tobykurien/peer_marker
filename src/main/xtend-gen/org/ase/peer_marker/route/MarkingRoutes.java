package org.ase.peer_marker.route;

import com.tobykurien.sparkler.Sparkler;
import org.ase.peer_marker.route.BaseRoute;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Functions.Function2;
import spark.Request;
import spark.Response;

@SuppressWarnings("all")
public class MarkingRoutes extends BaseRoute {
  public void load() {
    final Function2<Request,Response,String> _function = new Function2<Request,Response,String>() {
      public String apply(final Request req, final Response res) {
        String _xblockexpression = null;
        {
          res.type("application/json");
          StringConcatenation _builder = new StringConcatenation();
          _builder.append("[{\"answers\": 5, \"evaluations\": 0}, {\"answers\": 1, \"evaluations\": 1} ]");
          _xblockexpression = (_builder.toString());
        }
        return _xblockexpression;
      }
    };
    Sparkler.get("/api/marking", _function);
  }
}
