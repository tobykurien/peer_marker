package org.ase.peer_marker.route;

import com.tobykurien.sparkler.Sparkler;
import org.ase.peer_marker.model.Student;
import org.ase.peer_marker.route.BaseRoute;
import org.ase.peer_marker.transformer.JsonTransformer;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.Functions.Function2;
import org.javalite.activejdbc.LazyList;
import org.javalite.activejdbc.Model;
import org.javalite.activejdbc.ModelContext;
import spark.Request;
import spark.Response;
import spark.Session;

@SuppressWarnings("all")
public class StudentRoutes extends BaseRoute {
  private final ModelContext<Student> student = new Function0<ModelContext<Student>>() {
    public ModelContext<Student> apply() {
      ModelContext<Student> _with = Model.<Student>with(Student.class);
      return _with;
    }
  }.apply();
  
  public void load() {
    final Function2<Request,Response,LazyList<Student>> _function = new Function2<Request,Response,LazyList<Student>>() {
      public LazyList<Student> apply(final Request req, final Response res) {
        LazyList<Student> _all = StudentRoutes.this.student.all();
        return _all;
      }
    };
    JsonTransformer _jsonTransformer = new JsonTransformer("/api/students", _function);
    Sparkler.get(_jsonTransformer);
    final Function2<Request,Response,String> _function_1 = new Function2<Request,Response,String>() {
      public String apply(final Request req, final Response res) {
        String _xblockexpression = null;
        {
          Session _session = req.session();
          Object _attribute = _session.<Object>attribute("student");
          Student user = ((Student) _attribute);
          Object _get = user.get("username");
          boolean _equals = _get.equals("teacher");
          if (_equals) {
            user.setType("teacher");
          }
          StringConcatenation _builder = new StringConcatenation();
          _builder.append("{ \"name\": \"");
          Object _get_1 = user.get("username");
          _builder.append(_get_1, "");
          _builder.append("\", \"type\" : \"");
          String _type = user.getType();
          _builder.append(_type, "");
          _builder.append("\"}");
          _xblockexpression = (_builder.toString());
        }
        return _xblockexpression;
      }
    };
    Sparkler.get("/api/user", _function_1);
  }
}
