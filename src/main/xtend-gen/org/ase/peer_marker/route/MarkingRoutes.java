package org.ase.peer_marker.route;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.tobykurien.sparkler.Sparkler;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.ase.peer_marker.route.BaseRoute;
import org.ase.peer_marker.transformer.JsonTransformer;
import org.eclipse.xtext.xbase.lib.Functions.Function2;
import spark.Request;
import spark.Response;

@SuppressWarnings("all")
public class MarkingRoutes extends BaseRoute {
  public void load() {
    final Function2<Request,Response,List<Map<String,Integer>>> _function = new Function2<Request,Response,List<Map<String,Integer>>>() {
      public List<Map<String,Integer>> apply(final Request req, final Response res) {
        Map<String,Integer> _xsetliteral = null;
        Map<String,Integer> _tempMap = Maps.<String, Integer>newHashMap();
        _tempMap.put("answers", Integer.valueOf(5));
        _tempMap.put("evaluations", Integer.valueOf(0));
        _xsetliteral = Collections.<String, Integer>unmodifiableMap(_tempMap);
        Map<String,Integer> _xsetliteral_1 = null;
        Map<String,Integer> _tempMap_1 = Maps.<String, Integer>newHashMap();
        _tempMap_1.put("answers", Integer.valueOf(1));
        _tempMap_1.put("evaluations", Integer.valueOf(1));
        _xsetliteral_1 = Collections.<String, Integer>unmodifiableMap(_tempMap_1);
        return Collections.<Map<String, Integer>>unmodifiableList(Lists.<Map<String, Integer>>newArrayList(_xsetliteral, _xsetliteral_1));
      }
    };
    JsonTransformer _jsonTransformer = new JsonTransformer("/api/marking", _function);
    Sparkler.get(_jsonTransformer);
  }
}
