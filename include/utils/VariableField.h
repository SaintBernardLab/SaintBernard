
#ifndef VARIABLEFIELD_H
#define VARIABLEFIELD_H

#include "Moose.h"

#include "libmesh/point.h"

#include <vector>

/**
 * This class reads a text file and transfers values into xyz point at the cell centers
 *
 * Input Textfile FORMAT definition :
 * Line 1: comment to describe the parameters
 * Line 2: nx =      4, ny =      4, nz =        4                    // number of bins for each
 * direction Line 3: dx = 0.25 m, dy = 0.25 m, dz = 0.25 m		      // size of each bin Line
 * nx*ny*nz one value per line going through a grid xmin - > xmax; ymin - > ymax; zmin - > zmax
 */
class VariableField
{
public:
  VariableField(std::string filename);
  ~VariableField() {}

  // Value in the grid at point p

  int nx;
  int ny;
  int nz;
  Real dx;
  Real dy;
  Real dz;
  Real value(Point p);

private:
  std::vector<Real> data;
};

#endif // VARIABLEFIELD_H
