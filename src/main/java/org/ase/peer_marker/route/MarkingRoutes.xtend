package org.ase.peer_marker.route

import org.ase.peer_marker.model.Answer
import org.ase.peer_marker.model.Assignment
import org.ase.peer_marker.model.Comparison
import org.ase.peer_marker.model.Evaluation
import org.ase.peer_marker.pairing.PairingFactory
import org.ase.peer_marker.transformer.JsonTransformer
import org.javalite.activejdbc.Model
import org.json.JSONObject

import static org.ase.peer_marker.Constants.*

import static extension org.ase.peer_marker.Helper.*
import org.ase.peer_marker.utils.Log
import org.javalite.activejdbc.DB
import org.javalite.activejdbc.Base

/**
 * Routes used during the peer marking phase
 */
class MarkingRoutes extends BaseRoute {
   val assignment = Model.with(Assignment)
   val evaluation = Model.with(Evaluation)
   val comparison = Model.with(Comparison)
   val answer = Model.with(Answer)
   
   override load() {
      // Current assignment for marking
      get(new JsonTransformer("/api/mark") [ req, res |
         var assign = assignment.findFirst("status = ?", STATUS_MARKING)
         if (assign != null) {
            #{ "assignment" -> assign.toMap }
         } else {
            #{}
         }
      ])

      // Get a pair of answers for marking
      get(new JsonTransformer("/api/mark/pair") [ req, res |
         val assign = assignment.findFirst("status = ?", STATUS_MARKING)
         val answers = answer.where("assignment_id = ?", assign.id)
         val pairing = PairingFactory.getInstance(answers)
         pairing.getPair(req.student.longId).map [a|
            #{
               "id" -> a.longId,
               //"student_id" -> a.getLong("student_id"),
               "assignment_id" -> a.getLong("assignment_id"),
               "content" -> a.getString("content")
             }
         ]
      ])

      // Current marking progress
      get(new JsonTransformer("/api/marking") [ req, res |
         AssignmentRoutes.authenticate(req, res)
         val assign = assignment.findFirst("status = ?", STATUS_MARKING)
         if (assign != null) {
//            val answers = answer.where("assignment_id = ?", assign.id)
//            val data = answers.map[a|
//               val comps = comparison.count("answer1_id = ? or answer2_id = ?", a.id, a.id)
//               val m = a.toMap
//               m.put("evaluations", comps)
//               m
//            ]
//            
//            var buckets = #{}
//            data.forEach [d|
//               buckets.put()
//            ]
            
            // get data for answers and their comparisons
            var answers = answer.count("assignment_id = ?", assign.id)
            var evals = Base.findAll('''
               select answers.id as answer_id, count(*) as evals
               from answers, comparisons
               where answers.assignment_id = ? and 
                     (answers.id = comparisons.answer1_id or 
                      answers.id = comparisons.answer2_id) 
               group by answers.id
            ''', assign.id)
            
            // Convert to Map of "Number of evaluations" -> "Number of answers"
            val buckets = newHashMap("0" -> answers - evals.length)
            evals.forEach [e|
               val key = String.valueOf(e.get("evals"))
               var current = buckets.get(key)
               if (current == null) current = 0L
               buckets.put(key, current + 1)
            ]

            buckets
         } else {
            #[]
         }
      ])
      
      // Create a new evaluation
      // Sample data: {"score":6,"answer1_id":2,"answer2_id":3,"disable":true,
      //               "pcomment1":"d","ccomment1":"f","pcomment2":"g","ccomment2":"d"}
      post(
         new JsonTransformer("/api/marking") [ req, res |
            val j = new JSONObject(req.body)
            
            // calculate the score from -1 to 1           
            var score = j.getDouble("score")
            score = (score - 6.0d) / 5.0d
            
            // save the comparison
            comparison.createIt(
               "student_id", req.student.longId,
               "answer1_id", j.getLong("answer1_id"),
               "answer2_id", j.getLong("answer2_id"),
               "score", score
            )

            // save comments for answer1
            evaluation.createIt(
               "student_id", req.student.longId,
               "answer_id", j.getLong("answer1_id"),
               "pcomment", j.getString("pcomment1"),
               "ccomment", j.getString("ccomment1")
            )

            // save comments for answer2
            evaluation.createIt(
               "student_id", req.student.longId,
               "answer_id", j.getLong("answer2_id"),
               "pcomment", j.getString("pcomment2"),
               "ccomment", j.getString("ccomment2")
            )

           #{ "success" -> true }
         ])

   }

}
