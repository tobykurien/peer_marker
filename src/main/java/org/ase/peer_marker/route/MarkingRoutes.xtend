package org.ase.peer_marker.route

import org.ase.peer_marker.transformer.JsonTransformer

class MarkingRoutes extends BaseRoute {

   override load() {
      get(new JsonTransformer("/api/marking") [ req, res |
         #[
            #{"answers" -> 5, "evaluations" -> 0}, 
            #{"answers" -> 1, "evaluations" -> 1}
         ]
      ])
   }

}
