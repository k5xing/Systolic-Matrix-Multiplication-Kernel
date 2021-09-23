/* Adds cluster boxes around clusters. 
 * Puts in cluster labels, but assumes 14-point and width less than 
 * cluster width. 
 */ 
BEGIN { 
  double llx[graph_t], lly[graph_t], urx[graph_t], ury[graph_t]; 
  int mark[node_t]; 
  int cl_offset = 8; 
  node_t n; 
  graph_t sg; 
  double x, y, d, w2, h2, llx0, lly0, urx0, ury0; 

  graph_t clustBB (graph_t G) { 

    for (sg = fstsubg(G); sg; sg = nxtsubg(sg)) { 
          sg = clustBB(sg); 
    } 
    llx0 = 1000000; lly0 = 1000000; urx0 = -1000000; ury0 = -1000000; 
    for (sg = fstsubg(G); sg; sg = nxtsubg(sg)) { 
      d = llx[sg]; 
      if (d < llx0) llx0 = d; 
      d = lly[sg]; 
      if (d < lly0) lly0 = d; 
      d = urx[sg]; 
      if (d > urx0) urx0 = d; 
      d = ury[sg]; 
      if (d > ury0) ury0 = d; 
    } 
        if (G.name == "cluster*") { 
      for (n = fstnode(G); n; n = nxtnode_sg(G, n)) { 
        sscanf (n.pos, "%lf,%lf", &x, &y); 
        w2 = (36.0*(double)n.width); 
        h2 = (36.0*(double)n.height); 
        if ((x - w2) < llx0) llx0 = x - w2; 
        if ((x + w2) > urx0) urx0 = x + w2; 
        if ((y - h2) < lly0) lly0 = y - h2; 
        if ((y + h2) > ury0) ury0 = y + h2; 
      } 
      if (G.label != "") { 
        x = (llx0+urx0)/2.0; 
        y = ury0+10; 
        ury0 += 14; 
        G.lp = sprintf ("%.02f,%.02f", x, y); 
      } 
      llx0 -= cl_offset; 
      lly0 -= cl_offset; 
      urx0 += cl_offset; 
      ury0 += cl_offset; 
      G.bb = sprintf ("%lf,%lf,%lf,%lf", llx0, lly0, urx0, ury0); 
    } 
    llx[G] = llx0; 
    lly[G] = lly0; 
    urx[G] = urx0; 
    ury[G] = ury0; 
    return G; 
  } 
} 

BEG_G { 
  $.bb = ""; 
  clustBB($); 
} 
