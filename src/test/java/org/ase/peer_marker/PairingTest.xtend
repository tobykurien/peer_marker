package org.ase.peer_marker

import com.tobykurien.sparkler.test.TestSupport
import java.util.List
import org.ase.peer_marker.model.Answer
import org.ase.peer_marker.pairing.RandomPairing
import org.javalite.activejdbc.Model
import org.junit.Before
import org.junit.Test
import org.ase.peer_marker.pairing.PairingFactory

class PairingTest extends TestSupport {
   val answer = Model.with(Answer)
   var PairingFactory pairing
   
   override getModelPackageName() {
      Answer.package.name
   }
   
   @Test
   def shouldNotHang() {
      var ans1 = answer.create("student_id", 1L)
      var ans2 = answer.create("student_id", 2L)
   
      pairing = new RandomPairing(#[ans1, ans2])

      var List<Answer> pair = null
      var Exception err = null
      try {
         pair = pairing.getPair(1L)
      } catch (Exception e) {
         err = e
         System.err.println(e.message)
      }
      the(pair).shouldBeNull
      the(err).shouldNotBeNull
   }
   
   @Test
   def shouldGiveValidPair() {
      var ans1 = answer.create("student_id", 1L)
      var ans2 = answer.create("student_id", 2L)
      var ans3 = answer.create("student_id", 3L)
   
      var forStudent = 1L;
      pairing = new RandomPairing(#[ans1, ans2, ans3])
      var pair = pairing.getPair(forStudent)
      var valid = pairing.validatePair(pair.get(0), pair.get(1), forStudent)
      a(valid).shouldBeTrue 
   }

   @Test
   def shouldBeEmpty() {
      a(answer.findAll.length).shouldBeEqual(0)
   }
   
}