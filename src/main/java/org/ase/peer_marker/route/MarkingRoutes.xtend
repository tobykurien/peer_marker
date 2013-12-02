package org.ase.peer_marker.route

import org.ase.peer_marker.route.BaseRoute

class MarkingRoutes extends BaseRoute {

   override load() {
      get("/api/marking") [ req, res |
         res.type("application/json")
         '''[{"answers": 5, "evaluations": 0}, {"answers": 1, "evaluations": 1} ]'''
      ]

   }

}
