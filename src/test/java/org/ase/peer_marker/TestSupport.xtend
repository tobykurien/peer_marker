package org.ase.peer_marker

import com.tobykurien.sparkler.Helper
import com.tobykurien.sparkler.db.DatabaseManager
import com.tobykurien.sparkler.tools.Database
import org.javalite.activejdbc.Base
import org.javalite.test.jspec.JSpecSupport
import org.junit.AfterClass
import org.junit.BeforeClass

class TestSupport extends JSpecSupport {
   @BeforeClass
   def static setUpDb() {
      Helper.setEnvironment("test")
      new Database().init(#["test"])
      DatabaseManager.init(PairingTest.package.name)
      Base.open(DatabaseManager.newDataSource)
   }
   
   @AfterClass
   def static tearDownDb() {
      Base.close
   }
}