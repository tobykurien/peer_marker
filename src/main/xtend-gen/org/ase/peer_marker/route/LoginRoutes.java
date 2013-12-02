package org.ase.peer_marker.route;

import com.google.common.collect.Maps;
import com.tobykurien.sparkler.Sparkler;
import com.tobykurien.sparkler.db.DatabaseManager;
import java.util.Collections;
import java.util.Map;
import javax.sql.DataSource;
import org.ase.peer_marker.model.Student;
import org.ase.peer_marker.route.BaseRoute;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.Functions.Function2;
import org.javalite.activejdbc.Base;
import org.javalite.activejdbc.LazyList;
import org.javalite.activejdbc.Model;
import org.javalite.activejdbc.ModelContext;
import spark.Request;
import spark.Response;
import spark.Session;

@SuppressWarnings("all")
public class LoginRoutes extends BaseRoute {
  private final ModelContext<Student> student = new Function0<ModelContext<Student>>() {
    public ModelContext<Student> apply() {
      ModelContext<Student> _with = Model.<Student>with(Student.class);
      return _with;
    }
  }.apply();
  
  public void load() {
    final Function2<Request,Response,String> _function = new Function2<Request,Response,String>() {
      public String apply(final Request req, final Response res) {
        Map<String,Object> _xsetliteral = null;
        Map<String,Object> _tempMap = Maps.<String, Object>newHashMap();
        _xsetliteral = Collections.<String, Object>unmodifiableMap(_tempMap);
        String _render = Sparkler.render("views/app/login.html", _xsetliteral);
        return _render;
      }
    };
    Sparkler.get("/login", _function);
    final Function2<Request,Response,String> _function_1 = new Function2<Request,Response,String>() {
      public String apply(final Request req, final Response res) {
        String _xblockexpression = null;
        {
          DataSource _newDataSource = DatabaseManager.newDataSource();
          Base.open(_newDataSource);
          String _xtrycatchfinallyexpression = null;
          try {
            String _xblockexpression_1 = null;
            {
              String username = req.queryParams("username");
              Student ret = null;
              LazyList<Student> s = LoginRoutes.this.student.find("username =?", username);
              final LazyList<Student> _converted_s = (LazyList<Student>)s;
              int _length = ((Object[])Conversions.unwrapArray(_converted_s, Object.class)).length;
              boolean _equals = (_length == 0);
              if (_equals) {
                Student _createIt = LoginRoutes.this.student.createIt(
                  "username", username);
                ret = _createIt;
              } else {
                Student _get = s.get(0);
                ret = _get;
              }
              Session _session = req.session(true);
              _session.attribute("student", ret);
              res.redirect("/");
              _xblockexpression_1 = ("");
            }
            _xtrycatchfinallyexpression = _xblockexpression_1;
          } finally {
            Base.close();
          }
          _xblockexpression = (_xtrycatchfinallyexpression);
        }
        return _xblockexpression;
      }
    };
    Sparkler.post("/login", _function_1);
  }
}
