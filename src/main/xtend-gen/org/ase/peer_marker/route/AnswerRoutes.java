package org.ase.peer_marker.route;

import com.tobykurien.sparkler.Sparkler;
import org.ase.peer_marker.model.Answer;
import org.ase.peer_marker.model.Student;
import org.ase.peer_marker.route.BaseRoute;
import org.ase.peer_marker.transformer.JsonTransformer;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.Functions.Function2;
import org.javalite.activejdbc.LazyList;
import org.javalite.activejdbc.Model;
import org.javalite.activejdbc.ModelContext;
import org.json.JSONObject;
import spark.Request;
import spark.Response;
import spark.Session;

@SuppressWarnings("all")
public class AnswerRoutes extends BaseRoute {
  private final ModelContext<Answer> answer = new Function0<ModelContext<Answer>>() {
    public ModelContext<Answer> apply() {
      ModelContext<Answer> _with = Model.<Answer>with(Answer.class);
      return _with;
    }
  }.apply();
  
  public void load() {
    final Function2<Request,Response,LazyList<Model>> _function = new Function2<Request,Response,LazyList<Model>>() {
      public LazyList<Model> apply(final Request req, final Response res) {
        LazyList<Model> _xblockexpression = null;
        {
          Session _session = req.session();
          Object _attribute = _session.<Object>attribute("student");
          Student user = ((Student) _attribute);
          Object _id = user.getId();
          LazyList<Answer> _find = AnswerRoutes.this.answer.find("student_id = ?", _id);
          LazyList<Model> _include = _find.<Model>include(Student.class);
          _xblockexpression = (_include);
        }
        return _xblockexpression;
      }
    };
    JsonTransformer _jsonTransformer = new JsonTransformer("/api/answers", _function);
    Sparkler.get(_jsonTransformer);
    final Function2<Request,Response,Answer> _function_1 = new Function2<Request,Response,Answer>() {
      public Answer apply(final Request req, final Response res) {
        String _params = req.params("id");
        Answer _findById = AnswerRoutes.this.answer.findById(_params);
        return _findById;
      }
    };
    JsonTransformer _jsonTransformer_1 = new JsonTransformer("/api/answers/:id", _function_1);
    Sparkler.get(_jsonTransformer_1);
    final Function2<Request,Response,String> _function_2 = new Function2<Request,Response,String>() {
      public String apply(final Request req, final Response res) {
        String _xblockexpression = null;
        {
          String _body = req.body();
          JSONObject _jSONObject = new JSONObject(_body);
          JSONObject j = _jSONObject;
          Session _session = req.session();
          Object _attribute = _session.<Object>attribute("student");
          Student st = ((Student) _attribute);
          Object _id = st.getId();
          long _long = j.getLong("assignment");
          LazyList<Answer> ans = AnswerRoutes.this.answer.find("student_id = ? and assignment_id = ?", _id, Long.valueOf(_long));
          final LazyList<Answer> _converted_ans = (LazyList<Answer>)ans;
          int _length = ((Object[])Conversions.unwrapArray(_converted_ans, Object.class)).length;
          boolean _equals = (_length == 0);
          if (_equals) {
            Object _id_1 = st.getId();
            long _long_1 = j.getLong("assignment");
            String _string = j.getString("answer");
            AnswerRoutes.this.answer.createIt(
              "student_id", _id_1, 
              "assignment_id", Long.valueOf(_long_1), 
              "content", _string);
          } else {
            Answer _get = ans.get(0);
            Object _id_2 = st.getId();
            long _long_2 = j.getLong("assignment");
            String _string_1 = j.getString("answer");
            _get.set(
              "student_id", _id_2, 
              "assignment_id", Long.valueOf(_long_2), 
              "content", _string_1);
            Answer _get_1 = ans.get(0);
            _get_1.saveIt();
          }
          StringConcatenation _builder = new StringConcatenation();
          _builder.append("{\"success\": true}");
          _xblockexpression = (_builder.toString());
        }
        return _xblockexpression;
      }
    };
    JsonTransformer _jsonTransformer_2 = new JsonTransformer("/api/answer", _function_2);
    Sparkler.post(_jsonTransformer_2);
  }
}
