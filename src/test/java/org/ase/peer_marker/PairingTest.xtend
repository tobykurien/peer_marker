package org.ase.peer_marker

import com.tobykurien.sparkler.db.DatabaseManager
import org.ase.peer_marker.model.Answer
import org.javalite.activejdbc.Base
import org.javalite.activejdbc.Model
import org.javalite.test.jspec.JSpecSupport
import org.junit.After
import org.junit.Before
import org.junit.Test
import com.tobykurien.sparkler.Helper
import com.tobykurien.sparkler.tools.Database

class PairingTest extends JSpecSupport {

   @Before
   def setUp() {
      Helper.setEnvironment("test")
      new Database().init(#["test"]) 
      DatabaseManager.init(PairingTest.package.name)
      Base.open(DatabaseManager.newDataSource)
   }

   @After
   def tearDown() {
      Base.close
   }
   
   @Test
   def shouldPickValidAnswers() {
      var answer = Model.with(Answer)
      
      var ans = answer.create()
      ans.set("student_id", 1L)
      
      a(ans.studentId).shouldBeEqual(1L)
   }
   
}