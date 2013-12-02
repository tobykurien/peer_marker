package org.ase.peer_marker.route;

import com.google.common.collect.Sets;
import com.tobykurien.sparkler.Sparkler;
import java.util.Collections;
import org.ase.peer_marker.model.Assignment;
import org.ase.peer_marker.route.BaseRoute;
import org.ase.peer_marker.transformer.JsonTransformer;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.Functions.Function2;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.javalite.activejdbc.LazyList;
import org.javalite.activejdbc.Model;
import org.javalite.activejdbc.ModelContext;
import org.json.JSONObject;
import spark.Request;
import spark.Response;

@SuppressWarnings("all")
public class AssignmentRoutes extends BaseRoute {
  private final ModelContext<Assignment> assignment = new Function0<ModelContext<Assignment>>() {
    public ModelContext<Assignment> apply() {
      ModelContext<Assignment> _with = Model.<Assignment>with(Assignment.class);
      return _with;
    }
  }.apply();
  
  public void load() {
    final Function2<Request,Response,LazyList<Assignment>> _function = new Function2<Request,Response,LazyList<Assignment>>() {
      public LazyList<Assignment> apply(final Request req, final Response res) {
        LazyList<Assignment> _all = AssignmentRoutes.this.assignment.all();
        return _all;
      }
    };
    JsonTransformer _jsonTransformer = new JsonTransformer("/api/assignments", _function);
    Sparkler.get(_jsonTransformer);
    final Function2<Request,Response,Assignment> _function_1 = new Function2<Request,Response,Assignment>() {
      public Assignment apply(final Request req, final Response res) {
        Assignment _xblockexpression = null;
        {
          LazyList<Assignment> _find = AssignmentRoutes.this.assignment.find("status = ?", "EDITING");
          if (_find!=null) {
            final Procedure1<Assignment> _function = new Procedure1<Assignment>() {
              public void apply(final Assignment a) {
                a.set("status", "DONE");
                a.saveIt();
              }
            };
            IterableExtensions.<Assignment>forEach(_find, _function);
          }
          String _body = req.body();
          JSONObject _jSONObject = new JSONObject(_body);
          JSONObject j = _jSONObject;
          String _string = j.getString("name");
          String _string_1 = j.getString("question");
          String _string_2 = j.getString("status");
          Assignment _createIt = AssignmentRoutes.this.assignment.createIt(
            "name", _string, 
            "question", _string_1, 
            "status", _string_2);
          _xblockexpression = (_createIt);
        }
        return _xblockexpression;
      }
    };
    JsonTransformer _jsonTransformer_1 = new JsonTransformer("/api/assignment", _function_1);
    Sparkler.post(_jsonTransformer_1);
    final Function2<Request,Response,Integer> _function_2 = new Function2<Request,Response,Integer>() {
      public Integer apply(final Request req, final Response res) {
        int _xblockexpression = (int) 0;
        {
          String _body = req.body();
          JSONObject _jSONObject = new JSONObject(_body);
          JSONObject j = _jSONObject;
          String _string = j.getString("name");
          String _string_1 = j.getString("question");
          int _update = AssignmentRoutes.this.assignment.update(
            "name", _string, 
            "question", _string_1);
          _xblockexpression = (_update);
        }
        return Integer.valueOf(_xblockexpression);
      }
    };
    JsonTransformer _jsonTransformer_2 = new JsonTransformer("/api/assignment/:id", _function_2);
    Sparkler.put(_jsonTransformer_2);
    final Function2<Request,Response,Object> _function_3 = new Function2<Request,Response,Object>() {
      public Object apply(final Request req, final Response res) {
        Object _xblockexpression = null;
        {
          LazyList<Assignment> assigns = AssignmentRoutes.this.assignment.find("status = ?", "EDITING");
          Object _xifexpression = null;
          final LazyList<Assignment> _converted_assigns = (LazyList<Assignment>)assigns;
          int _length = ((Object[])Conversions.unwrapArray(_converted_assigns, Object.class)).length;
          boolean _greaterThan = (_length > 0);
          if (_greaterThan) {
            Assignment _get = assigns.get(0);
            _xifexpression = _get;
          } else {
            _xifexpression = Collections.<Object>unmodifiableSet(Sets.<Object>newHashSet());
          }
          _xblockexpression = (_xifexpression);
        }
        return _xblockexpression;
      }
    };
    JsonTransformer _jsonTransformer_3 = new JsonTransformer("/api/assignment", _function_3);
    Sparkler.get(_jsonTransformer_3);
  }
}
